class Chat {
  final String id;
  final String participantName;
  final String participantId;
  final String? participantImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final String participantRole; // e.g., 'Student', 'Parent', 'Staff'

  Chat({
    required this.id,
    required this.participantName,
    required this.participantId,
    this.participantImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.participantRole,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? '',
      participantName: json['participant_name'] ?? '',
      participantId: json['participant_id'] ?? '',
      participantImage: json['participant_image'],
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
      participantRole: json['participant_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_name': participantName,
      'participant_id': participantId,
      'participant_image': participantImage,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'unread_count': unreadCount,
      'participant_role': participantRole,
    };
  }
}

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      chatId: json['chat_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isMe: json['is_me'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'timestamp': timestamp,
      'is_me': isMe,
    };
  }
}

class ChatParticipant {
  final String id;
  final String name;
  final String role;
  final String? image;

  ChatParticipant({
    required this.id,
    required this.name,
    required this.role,
    this.image,
  });
}
