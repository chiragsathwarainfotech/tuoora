import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/services/chat_socket_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/chat_model.dart';
import 'package:tuoora/data/repositories_impl/chat_repository_impl.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository);

  final isLoading = false.obs;
  final isSending = false.obs;
  final chatsList = <Chat>[].obs;
  final filteredChats = <Chat>[].obs;
  final searchQuery = ''.obs;

  final messages = <Message>[].obs;
  final selectedChat = Rxn<Chat>();
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final availableParticipants = <ChatParticipant>[].obs;
  final filteredParticipants = <ChatParticipant>[].obs;
  final participantSearchQuery = ''.obs;

  /// Logged-in user identity in the chat domain. Sourced from the chat list
  /// response (which carries my_id/my_type) and falls back to AuthService
  /// for first-time users with no existing chats.
  String? _myUserId;
  String? _myUserType;

  StreamSubscription<Message>? _onMessageSentSub;
  StreamSubscription<MessageAck>? _onMessageReceivedSub;
  StreamSubscription<MessageAck>? _onMessageReadSub;
  StreamSubscription<ChatDeleted>? _onChatDeletedSub;

  @override
  void onInit() {
    super.onInit();
    _subscribeToSocketStreams();
    fetchChats();

    debounce(
      searchQuery,
      (_) => _filterChats(),
      time: const Duration(milliseconds: 300),
    );
    debounce(
      participantSearchQuery,
      (_) => _filterParticipants(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _onMessageSentSub?.cancel();
    _onMessageReceivedSub?.cancel();
    _onMessageReadSub?.cancel();
    _onChatDeletedSub?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------- chats

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final chats = await _chatRepository.getChats();
      chatsList.assignAll(chats);
      _filterChats();

      // Derive my identity from any chat (the backend embeds my_id/my_type
      // on every entry). Fall back to AuthService if there are no chats yet.
      if (chats.isNotEmpty &&
          chats.first.myId != null &&
          chats.first.myRole != null) {
        _myUserId = chats.first.myId;
        _myUserType = chats.first.myRole;
      } else {
        _deriveMyIdentityFromAuth();
      }

      // Best-effort socket connect — failures don't block the chat list.
      _ensureSocketConnected();
    } catch (e) {
      AppSnackBar.error('Failed to load chats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _deriveMyIdentityFromAuth() {
    if (!Get.isRegistered<AuthService>()) return;
    final user = Get.find<AuthService>().currentUser;
    if (user == null) return;
    _myUserId = user.id.toString();
    _myUserType = _mapAuthRoleToChatType(user.role);
  }

  /// AuthService stores roles in shouty form (`'INSTITUTE'`, `'STUDENT'`,
  /// `'PARENT'`) while the chat backend uses model names. Map here once.
  String _mapAuthRoleToChatType(String role) {
    switch (role.toUpperCase()) {
      case 'INSTITUTE':
        return 'Institute';
      case 'STAFF':
        return 'Staff';
      case 'STUDENT':
        return 'Student';
      case 'PARENT':
        return 'StudentParent';
      default:
        return role;
    }
  }

  void _filterChats() {
    if (searchQuery.value.isEmpty) {
      filteredChats.assignAll(chatsList);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredChats.assignAll(
        chatsList.where(
          (chat) =>
              chat.participantName.toLowerCase().contains(query) ||
              chat.lastMessage.toLowerCase().contains(query),
        ),
      );
    }
  }

  // ----------------------------------------------------------- messages

  Future<void> fetchMessages(String chatId) async {
    try {
      isLoading.value = true;
      final chatMessages = await _chatRepository.getChatMessages(
        chatId,
        myUserId: _myUserId ?? '',
        myUserType: _myUserType ?? '',
      );
      messages.assignAll(chatMessages);
      if (kDebugMode) {
        final mine = chatMessages.where((m) => m.isMe).toList();
        final invariantBreaks = mine
            .where((m) => m.readAt != null && m.receivedAt == null)
            .map((m) => m.id)
            .toList();
        debugPrint(
          '[ChatController] /chat/messages — ${chatMessages.length} total, '
          '${mine.length} mine. Mine read-without-received '
          '(impossible state from backend): $invariantBreaks',
        );
      }
      _scrollToBottom();
    } catch (e) {
      AppSnackBar.error(
        'Failed to load messages: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    final chat = selectedChat.value;
    if (content.isEmpty || chat == null || isSending.value) return;

    final receiverId = int.tryParse(chat.participantId);
    if (receiverId == null) {
      AppSnackBar.error('Invalid recipient');
      return;
    }

    // Optimistic insert so the bubble shows up instantly (single grey tick).
    final now = DateTime.now();
    final optimistic = Message(
      id: '',
      chatId: chat.id,
      senderId: _myUserId ?? '',
      senderType: _myUserType ?? '',
      receiverId: chat.participantId,
      receiverType: chat.participantRole,
      content: content,
      messageType: 'text',
      createdAt: now,
      isMe: true,
      timestamp: DateFormat('h:mm a').format(now),
    );
    messages.add(optimistic);
    messageController.clear();
    _scrollToBottom();

    try {
      isSending.value = true;
      final sent = await _chatRepository.sendMessage(
        receiverId: receiverId,
        receiverType: chat.participantRole,
        message: content,
        myUserId: _myUserId ?? '',
        myUserType: _myUserType ?? '',
      );
      if (kDebugMode) {
        debugPrint(
          '[ChatController] /chat/send response — id=${sent.id} '
          'readAt=${sent.readAt} receivedAt=${sent.receivedAt} '
          'status=${sent.status}',
        );
      }
      _replaceOptimisticWithCanonical(optimistic, sent);
      // Refresh the chat list so the latest preview + ordering reflects it.
      _bumpChatPreview(sent);
    } catch (e) {
      _markOptimisticFailed(optimistic);
      AppSnackBar.error(
        'Failed to send: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isSending.value = false;
    }
  }

  /// Re-attempts a message whose previous send was marked as `failed`.
  /// Removes the failed bubble from the list and re-fires either the text
  /// or attachment send path depending on the message type.
  ///
  /// Note: if the backend persisted the original send but failed to return
  /// a 2xx response (e.g. a 500 caused by serialization), retrying creates
  /// a duplicate. The chat-history endpoint is the only source of truth in
  /// that case — the user can swipe back and reopen to reconcile, or just
  /// delete the duplicate.
  Future<void> retrySend(Message failed) async {
    if (!failed.failed) return;
    final chat = selectedChat.value;
    if (chat == null) return;

    final attachmentPath = failed.attachment;
    final hasLocalAttachment =
        attachmentPath != null && !attachmentPath.startsWith('http');

    messages.remove(failed);

    if (hasLocalAttachment) {
      final file = File(attachmentPath);
      if (!await file.exists()) {
        AppSnackBar.error(
          'Cannot retry — the original file is no longer on this device. '
          'Pick it again from the attachment menu.',
        );
        // Keep the failed bubble visible so user knows it didn't go.
        messages.add(failed);
        return;
      }
      await sendAttachment(
        file: file,
        type: failed.messageType,
        caption: failed.content,
      );
    } else {
      // Text retry — reuse sendMessage by feeding the controller.
      messageController.text = failed.content;
      await sendMessage();
    }
  }

  /// Sends a file attachment (image/video/audio/document). The bubble shows
  /// the local file immediately (optimistic), then swaps to the server's
  /// URL once the upload returns.
  Future<void> sendAttachment({
    required File file,
    required String type, // 'image' | 'video' | 'audio' | 'document'
    String caption = '',
  }) async {
    final chat = selectedChat.value;
    if (chat == null || isSending.value) return;

    final receiverId = int.tryParse(chat.participantId);
    if (receiverId == null) {
      AppSnackBar.error('Invalid recipient');
      return;
    }

    final now = DateTime.now();
    final optimistic = Message(
      id: '',
      chatId: chat.id,
      senderId: _myUserId ?? '',
      senderType: _myUserType ?? '',
      receiverId: chat.participantId,
      receiverType: chat.participantRole,
      content: caption,
      messageType: type,
      // Local file path — the bubble renderer falls back to Image.file /
      // file-aware widgets when the attachment doesn't start with http.
      attachment: file.path,
      createdAt: now,
      isMe: true,
      timestamp: DateFormat('h:mm a').format(now),
    );
    messages.add(optimistic);
    _scrollToBottom();

    try {
      isSending.value = true;
      final sent = await _chatRepository.sendMessage(
        receiverId: receiverId,
        receiverType: chat.participantRole,
        message: caption,
        type: type,
        attachment: file,
        myUserId: _myUserId ?? '',
        myUserType: _myUserType ?? '',
      );
      if (kDebugMode) {
        debugPrint(
          '[ChatController] /chat/send (attachment) response — id=${sent.id} '
          'type=${sent.messageType} attachment=${sent.attachment}',
        );
      }
      _replaceOptimisticWithCanonical(optimistic, sent);
      _bumpChatPreview(sent);
    } catch (e) {
      _markOptimisticFailed(optimistic);
      AppSnackBar.error(
        'Failed to send: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isSending.value = false;
    }
  }

  void _replaceOptimisticWithCanonical(Message optimistic, Message canonical) {
    final idx = messages.indexOf(optimistic);
    if (idx == -1) {
      // The socket echoed the message back before our HTTP response. If we
      // haven't already accepted it, append; otherwise leave it alone.
      if (!messages.any((m) => m.id == canonical.id && canonical.id.isNotEmpty)) {
        messages.add(canonical);
      }
      return;
    }
    messages[idx] = canonical;
  }

  void _markOptimisticFailed(Message optimistic) {
    final idx = messages.indexOf(optimistic);
    if (idx == -1) return;
    messages[idx] = optimistic.copyWith(failed: true);
  }

  // ----------------------------------------------------- socket handlers

  void _subscribeToSocketStreams() {
    if (!Get.isRegistered<ChatSocketService>()) {
      if (kDebugMode) {
        debugPrint(
          '[ChatController] ChatSocketService not registered — no '
          'realtime events will arrive. Check InstituteBinding.',
        );
      }
      return;
    }
    final socket = Get.find<ChatSocketService>();
    _onMessageSentSub = socket.onMessageSent.listen(_onIncomingMessage);
    _onMessageReceivedSub =
        socket.onMessageReceived.listen(_onMessageReceivedAck);
    _onMessageReadSub = socket.onMessageRead.listen(_onMessageReadAck);
    _onChatDeletedSub = socket.onChatDeleted.listen(_onChatDeletedRemote);
    if (kDebugMode) {
      debugPrint('[ChatController] subscribed to socket streams');
    }
  }

  Future<void> _ensureSocketConnected() async {
    if (_myUserId == null || _myUserType == null) return;
    if (!Get.isRegistered<AuthService>() ||
        !Get.isRegistered<ChatSocketService>()) {
      return;
    }
    final auth = Get.find<AuthService>();
    if (!auth.isAuthenticated) return;
    await Get.find<ChatSocketService>().connect(
      myUserId: _myUserId!,
      myUserType: _myUserType!,
      authToken: auth.token,
    );
  }

  void _onIncomingMessage(Message msg) {
    if (kDebugMode) {
      final openId = selectedChat.value?.id;
      debugPrint(
        '[ChatController] incoming message id=${msg.id} chatId=${msg.chatId} '
        'isMe=${msg.isMe} openChat=$openId',
      );
    }
    // Drop duplicates — the same message arrives via our own send response
    // AND via the broadcast echo on our own channel.
    if (msg.id.isNotEmpty && messages.any((m) => m.id == msg.id)) return;

    if (msg.isMe) {
      // Multi-device echo of our own send. Append only if visible.
      if (selectedChat.value?.id == msg.chatId) {
        messages.add(msg);
        _scrollToBottom();
      }
      return;
    }

    // Incoming from the other side — always confirm delivery to the server.
    final mid = int.tryParse(msg.id);
    if (mid != null) {
      _chatRepository.markReceived(mid).catchError((_) => null);
    }

    if (selectedChat.value?.id == msg.chatId) {
      // User is actively viewing the chat → show + mark read.
      messages.add(msg);
      _scrollToBottom();
      // Also refresh the list-tile preview so it's correct when the
      // user navigates back (unread count stays 0 — they're reading it
      // right now).
      _bumpChatPreview(msg);
      if (mid != null) {
        _chatRepository.markRead(mid).catchError((_) => null);
      }
    } else {
      // Background — update the list tile, bump unread count.
      _bumpUnreadFor(msg);
    }
  }

  void _onMessageReceivedAck(MessageAck ack) {
    if (kDebugMode) {
      debugPrint(
        '[ChatController] MessageReceived ack id=${ack.messageId} '
        'at=${ack.timestamp}',
      );
    }
    _updateMessageStatus(ack.messageId, receivedAt: ack.timestamp);
  }

  void _onMessageReadAck(MessageAck ack) {
    if (kDebugMode) {
      debugPrint(
        '[ChatController] MessageRead ack id=${ack.messageId} '
        'at=${ack.timestamp}',
      );
    }
    _updateMessageStatus(ack.messageId, readAt: ack.timestamp);
  }

  void _updateMessageStatus(
    String messageId, {
    DateTime? receivedAt,
    DateTime? readAt,
  }) {
    final idx = messages.indexWhere((m) => m.id == messageId);
    if (idx == -1) {
      if (kDebugMode) {
        debugPrint(
          '[ChatController] _updateMessageStatus: id=$messageId not in '
          'open conversation (size=${messages.length})',
        );
      }
      return;
    }
    final before = messages[idx];
    final after = before.copyWith(receivedAt: receivedAt, readAt: readAt);
    messages[idx] = after;
    if (kDebugMode) {
      debugPrint(
        '[ChatController] status update id=$messageId: '
        'received "${before.receivedAt}"→"${after.receivedAt}", '
        'read "${before.readAt}"→"${after.readAt}", '
        'status ${before.status}→${after.status}',
      );
    }
  }

  void _bumpUnreadFor(Message msg) {
    final idx = chatsList.indexWhere((c) => c.id == msg.chatId);
    if (idx == -1) {
      // Brand-new conversation we didn't know about — pull the list fresh.
      fetchChats();
      return;
    }
    final old = chatsList[idx];
    final updated = old.copyWith(
      lastMessage: msg.content,
      lastMessageType: msg.messageType,
      lastMessageAt: msg.createdAt,
      lastMessageTime:
          msg.createdAt == null ? old.lastMessageTime : msg.timestamp,
      unreadCount: old.unreadCount + 1,
    );
    _moveToTop(idx, updated);
  }

  void _bumpChatPreview(Message msg) {
    final idx = chatsList.indexWhere((c) => c.id == msg.chatId);
    if (idx == -1) return;
    final old = chatsList[idx];
    final updated = old.copyWith(
      lastMessage: msg.content,
      lastMessageType: msg.messageType,
      lastMessageAt: msg.createdAt,
      lastMessageTime: msg.timestamp,
    );
    _moveToTop(idx, updated);
  }

  /// Replaces the chat at [oldIndex] with [updated] and moves it to the top
  /// of the list. Matches WhatsApp-style ordering: the most recent
  /// conversation always sits at index 0.
  void _moveToTop(int oldIndex, Chat updated) {
    chatsList.removeAt(oldIndex);
    chatsList.insert(0, updated);
    _filterChats();
  }

  // ----------------------------------------------------- participants

  Future<void> fetchParticipants() async {
    try {
      isLoading.value = true;
      final participants = await _chatRepository.getAvailableParticipants();
      availableParticipants.assignAll(participants);
      _filterParticipants();
    } catch (e) {
      AppSnackBar.error('Failed to load members: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterParticipants() {
    if (participantSearchQuery.value.isEmpty) {
      filteredParticipants.assignAll(availableParticipants);
    } else {
      final query = participantSearchQuery.value.toLowerCase();
      filteredParticipants.assignAll(
        availableParticipants.where(
          (p) => p.name.toLowerCase().contains(query),
        ),
      );
    }
  }

  void startChatWithParticipant(ChatParticipant participant) {
    final composedId = '${participant.role}_${participant.id}';
    final existing = chatsList.firstWhereOrNull((c) => c.id == composedId);
    if (existing != null) {
      openChat(existing);
      return;
    }
    final newChat = Chat(
      id: composedId,
      participantName: participant.name,
      participantId: participant.id,
      participantImage: participant.image,
      lastMessage: '',
      lastMessageTime: '',
      participantRole: participant.role,
      myId: _myUserId,
      myRole: _myUserType,
    );
    openChat(newChat);
  }

  void openChat(Chat chat) {
    selectedChat.value = chat;
    messages.clear();
    fetchMessages(chat.id);

    // Clear local unread badge as soon as the chat opens. The history
    // endpoint server-side appears to already bulk-mark messages as read.
    final idx = chatsList.indexWhere((c) => c.id == chat.id);
    if (idx != -1 && chatsList[idx].unreadCount > 0) {
      chatsList[idx] = chatsList[idx].copyWith(unreadCount: 0);
      _filterChats();
    }

    Get.toNamed(AppRoutes.instituteChatMessages);
  }

  /// Called when the user leaves the chat messages screen (via system back,
  /// gesture, or the app bar). Clears the "currently open" state so that
  /// subsequent incoming messages route through the unread/preview path
  /// instead of being silently appended and auto-marked-as-read.
  void closeChat() {
    selectedChat.value = null;
    messages.clear();
  }

  /// Deletes the current conversation (or [chat] if provided) on the server,
  /// then removes it from the local chat list. When the chat is currently
  /// open, pops the messages screen back to the chat list.
  Future<void> deleteConversation([Chat? chat]) async {
    final target = chat ?? selectedChat.value;
    if (target == null) return;
    final receiverId = int.tryParse(target.participantId);
    if (receiverId == null) {
      AppSnackBar.error('Invalid conversation');
      return;
    }

    try {
      isLoading.value = true;
      await _chatRepository.deleteConversation(
        userId: receiverId,
        userType: target.participantRole,
      );
      _removeChatLocally(target.id);
      // If we're sitting on the chat-messages route, pop back to the list.
      if (Get.currentRoute == AppRoutes.instituteChatMessages) {
        Get.until(
          (route) => route.settings.name != AppRoutes.instituteChatMessages,
        );
      }
      closeChat();
      AppSnackBar.success('Conversation deleted');
    } catch (e) {
      AppSnackBar.error(
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles a `ChatDeleted` event fired from the server (because the OTHER
  /// participant — or one of our own other devices — deleted the
  /// conversation).
  void _onChatDeletedRemote(ChatDeleted event) {
    final id = event.chatId;
    if (kDebugMode) {
      debugPrint('[ChatController] remote ChatDeleted chatId=$id');
    }
    if (id == null) {
      // No usable identifier — refresh the whole list as a fallback.
      fetchChats();
      return;
    }
    _removeChatLocally(id);
    if (selectedChat.value?.id == id) {
      if (Get.currentRoute == AppRoutes.instituteChatMessages) {
        Get.until(
          (route) => route.settings.name != AppRoutes.instituteChatMessages,
        );
      }
      closeChat();
      AppSnackBar.success('This conversation was deleted');
    }
  }

  void _removeChatLocally(String chatId) {
    chatsList.removeWhere((c) => c.id == chatId);
    _filterChats();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
