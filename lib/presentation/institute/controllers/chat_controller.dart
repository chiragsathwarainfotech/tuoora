import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/chat_model.dart';
import 'package:fee_easy/data/repositories_impl/chat_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository);

  final isLoading = false.obs;
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

  @override
  void onInit() {
    super.onInit();
    fetchChats();
    
    debounce(searchQuery, (_) => _filterChats(), time: const Duration(milliseconds: 300));
    debounce(participantSearchQuery, (_) => _filterParticipants(), time: const Duration(milliseconds: 300));
  }

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final chats = await _chatRepository.getChats();
      chatsList.assignAll(chats);
      _filterChats();
    } catch (e) {
      AppSnackbar.error('Failed to load chats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterChats() {
    if (searchQuery.value.isEmpty) {
      filteredChats.assignAll(chatsList);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredChats.assignAll(
        chatsList.where((chat) =>
            chat.participantName.toLowerCase().contains(query) ||
            chat.lastMessage.toLowerCase().contains(query)).toList(),
      );
    }
  }

  Future<void> fetchMessages(String chatId) async {
    try {
      isLoading.value = true;
      final chatMessages = await _chatRepository.getChatMessages(chatId);
      messages.assignAll(chatMessages);
      _scrollToBottom();
    } catch (e) {
      AppSnackbar.error('Failed to load messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty || selectedChat.value == null) return;

    try {
      final chatId = selectedChat.value!.id;
      messageController.clear();
      await _chatRepository.sendMessage(chatId, content);
      
      // Local update for immediate feedback
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: 'me',
        content: content,
        timestamp: 'Now',
        isMe: true,
      );
      messages.add(newMessage);
      _scrollToBottom();
      fetchChats(); // Refresh last message in list
    } catch (e) {
      AppSnackbar.error('Failed to send message: $e');
    }
  }

  Future<void> fetchParticipants() async {
    try {
      isLoading.value = true;
      final participants = await _chatRepository.getAvailableParticipants();
      availableParticipants.assignAll(participants);
      _filterParticipants();
    } catch (e) {
      AppSnackbar.error('Failed to load members: $e');
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
        availableParticipants.where((p) => p.name.toLowerCase().contains(query)).toList(),
      );
    }
  }

  void startChatWithParticipant(ChatParticipant participant) {
    // Check if chat already exists
    final existingChat = chatsList.firstWhereOrNull(
      (c) => c.participantId == participant.id,
    );

    if (existingChat != null) {
      openChat(existingChat);
    } else {
      // Create a temporary chat object for the UI
      final newChat = Chat(
        id: 'new_${participant.id}',
        participantName: participant.name,
        participantId: participant.id,
        lastMessage: '',
        lastMessageTime: '',
        participantRole: participant.role,
      );
      openChat(newChat);
    }
  }

  void openChat(Chat chat) {
    selectedChat.value = chat;
    messages.clear();
    if (!chat.id.startsWith('new_')) {
      fetchMessages(chat.id);
    }
    Get.toNamed(AppRoutes.instituteChatMessages);
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

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

