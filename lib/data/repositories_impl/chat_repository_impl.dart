import 'dart:io';

import 'package:get/get.dart';

import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/chat_model.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();

  /// Loads existing message history with the participant encoded by
  /// [chatId] (format: `"<otherType>_<otherId>"`). [myUserId]/[myUserType]
  /// are needed to compute the `isMe` flag for each message.
  ///
  /// Paginated: [page] 1 is the most recent block; higher pages are older
  /// history. [perPage] controls the page size.
  Future<List<Message>> getChatMessages(
    String chatId, {
    required String myUserId,
    required String myUserType,
    int page = 1,
    int perPage = 20,
  });

  Future<List<ChatParticipant>> getAvailableParticipants();

  /// Sends a text/attachment message. Returns the server-canonical Message.
  /// [receiverType] is the bare model name (`Institute`, `Student`, `Staff`,
  /// `StudentParent`) — this method prefixes it with `App\Models\` as the
  /// backend expects.
  ///
  /// Pass [attachment] only for `type` in {image, video, audio, document};
  /// the request switches to `multipart/form-data` automatically when set.
  Future<Message> sendMessage({
    required int receiverId,
    required String receiverType,
    required String message,
    String type = 'text',
    File? attachment,
    required String myUserId,
    required String myUserType,
  });

  /// Marks the given message as delivered to the recipient device.
  /// Returns the updated `received_at` timestamp (UTC) when reported by
  /// the server, or `null` if the server didn't echo it.
  Future<DateTime?> markReceived(int messageId);

  /// Marks the given message as read by the recipient.
  Future<DateTime?> markRead(int messageId);

  /// Deletes the entire conversation with the given user. [userType] is the
  /// bare model name (`Institute`, `Student`, `Staff`, `StudentParent`).
  Future<void> deleteConversation({
    required int userId,
    required String userType,
  });
}

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;

  ChatRepositoryImpl(this._apiClient);

  @override
  Future<List<Chat>> getChats() async {
    final response = await _apiClient.get(ApiConstants.chatList);
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to fetch chats',
      );
    }
    final body = response.body;
    final data = body is Map<String, dynamic> ? body['data'] : null;
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => Chat.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<ChatParticipant>> getAvailableParticipants() async {
    final response = await _apiClient.get(ApiConstants.chatContacts);
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to fetch contacts',
      );
    }
    final body = response.body;
    final list = body is List
        ? body
        : (body is Map<String, dynamic> ? body['data'] : null);
    if (list is! List) return const [];
    return list
        .whereType<Map>()
        .map((e) => ChatParticipant.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Message> sendMessage({
    required int receiverId,
    required String receiverType,
    required String message,
    String type = 'text',
    File? attachment,
    required String myUserId,
    required String myUserType,
  }) async {
    final commonFields = <String, dynamic>{
      'receiver_id': receiverId.toString(),
      'receiver_type': 'App\\Models\\$receiverType',
      'message': message,
      'type': type,
    };

    final response = attachment == null
        ? await _apiClient.post(ApiConstants.chatSend, {
            ...commonFields,
            'receiver_id': receiverId, // keep int when JSON
          })
        : await _apiClient.post(
            ApiConstants.chatSend,
            FormData({
              ...commonFields,
              'attachment': MultipartFile(
                attachment,
                filename: attachment.uri.pathSegments.isEmpty
                    ? 'attachment'
                    : attachment.uri.pathSegments.last,
              ),
            }),
          );

    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to send message',
      );
    }
    final data = response.body is Map<String, dynamic>
        ? response.body['data']
        : null;
    if (data is! Map) {
      throw Exception('Invalid send-message response');
    }
    return Message.fromJson(
      Map<String, dynamic>.from(data),
      myUserId: myUserId,
      myUserType: myUserType,
    );
  }

  @override
  Future<DateTime?> markReceived(int messageId) async {
    final response = await _apiClient.post(
      ApiConstants.chatMarkReceived,
      {'message_id': messageId},
    );
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to mark received',
      );
    }
    final data = response.body is Map<String, dynamic>
        ? response.body['data']
        : null;
    final raw = data is Map ? data['received_at']?.toString() : null;
    return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
  }

  @override
  Future<void> deleteConversation({
    required int userId,
    required String userType,
  }) async {
    // GetConnect's `delete` doesn't carry a body — pass as query params.
    // Laravel reads `$request->user_id` identically from query or body.
    final response = await _apiClient.delete(
      ApiConstants.chatConversation,
      query: {
        'user_id': userId.toString(),
        'user_type': userType,
      },
    );
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to delete conversation',
      );
    }
  }

  @override
  Future<DateTime?> markRead(int messageId) async {
    final response = await _apiClient.post(
      ApiConstants.chatMarkRead,
      {'message_id': messageId},
    );
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to mark read',
      );
    }
    final data = response.body is Map<String, dynamic>
        ? response.body['data']
        : null;
    final raw = data is Map ? data['read_at']?.toString() : null;
    return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
  }

  @override
  Future<List<Message>> getChatMessages(
    String chatId, {
    required String myUserId,
    required String myUserType,
    int page = 1,
    int perPage = 20,
  }) async {
    // chatId is synthesized as "<otherType>_<otherId>" by the chat list/
    // contacts parsers. Split on the first underscore so multi-word types
    // like "StudentParent" survive the round-trip.
    final cut = chatId.indexOf('_');
    if (cut <= 0 || cut == chatId.length - 1) {
      throw Exception('Invalid chat id: $chatId');
    }
    final otherType = chatId.substring(0, cut);
    final otherId = chatId.substring(cut + 1);

    final response = await _apiClient.get(
      ApiConstants.chatMessages(otherId),
      query: {
        'type': otherType,
        'page': '$page',
        'per_page': '$perPage',
      },
    );
    if (response.status.hasError) {
      throw Exception(
        response.body?['message'] ?? 'Failed to fetch messages',
      );
    }
    final body = response.body;
    final data = body is Map<String, dynamic> ? body['data'] : null;
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => Message.fromJson(
              Map<String, dynamic>.from(e),
              myUserId: myUserId,
              myUserType: myUserType,
            ))
        .toList();
  }
}
