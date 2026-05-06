import 'package:fee_easy/data/models/chat_model.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<List<Message>> getChatMessages(String chatId);
  Future<void> sendMessage(String chatId, String content);
  Future<List<ChatParticipant>> getAvailableParticipants();
}

class ChatRepositoryImpl implements ChatRepository {
  final List<Chat> _mockChats = [
    Chat(
      id: '1',
      participantName: 'Rahul Sharma',
      participantId: 's1',
      lastMessage: 'Sir, I have submitted the assignment.',
      lastMessageTime: '10:30 AM',
      unreadCount: 2,
      participantRole: 'Student',
    ),
    Chat(
      id: '2',
      participantName: 'Priya Verma',
      participantId: 'p1',
      lastMessage: 'Thank you for the update.',
      lastMessageTime: 'Yesterday',
      unreadCount: 0,
      participantRole: 'Parent',
    ),
    Chat(
      id: '3',
      participantName: 'Amit Patel',
      participantId: 's2',
      lastMessage: 'Will there be a class tomorrow?',
      lastMessageTime: 'Monday',
      unreadCount: 0,
      participantRole: 'Student',
    ),
  ];

  final Map<String, List<Message>> _mockMessages = {
    '1': [
      Message(id: 'm1', chatId: '1', senderId: 's1', content: 'Hello Sir!', timestamp: '10:00 AM', isMe: false),
      Message(id: 'm2', chatId: '1', senderId: 'me', content: 'Hello Rahul, how can I help you?', timestamp: '10:05 AM', isMe: true),
      Message(id: 'm3', chatId: '1', senderId: 's1', content: 'Sir, I have submitted the assignment.', timestamp: '10:30 AM', isMe: false),
    ],
    '2': [
      Message(id: 'm4', chatId: '2', senderId: 'p1', content: 'Is the fee receipt generated?', timestamp: 'Yesterday', isMe: false),
      Message(id: 'm5', chatId: '2', senderId: 'me', content: 'Yes, it is available in the portal.', timestamp: 'Yesterday', isMe: true),
      Message(id: 'm6', chatId: '2', senderId: 'p1', content: 'Thank you for the update.', timestamp: 'Yesterday', isMe: false),
    ],
  };

  final List<ChatParticipant> _mockParticipants = [
    ChatParticipant(id: 's1', name: 'Rahul Sharma', role: 'Student'),
    ChatParticipant(id: 'p1', name: 'Priya Verma', role: 'Parent'),
    ChatParticipant(id: 's2', name: 'Amit Patel', role: 'Student'),
    ChatParticipant(id: 's3', name: 'Sneha Gupta', role: 'Student'),
    ChatParticipant(id: 'p2', name: 'Rajesh Kumar', role: 'Parent'),
  ];

  @override
  Future<List<Chat>> getChats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockChats;
  }

  @override
  Future<List<Message>> getChatMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMessages[chatId] ?? [];
  }

  @override
  Future<void> sendMessage(String chatId, String content) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: 'me',
      content: content,
      timestamp: 'Now',
      isMe: true,
    );
    
    if (_mockMessages.containsKey(chatId)) {
      _mockMessages[chatId]!.add(newMessage);
    } else {
      _mockMessages[chatId] = [newMessage];
    }

    // Update last message in chat list
    final chatIndex = _mockChats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final oldChat = _mockChats[chatIndex];
      _mockChats[chatIndex] = Chat(
        id: oldChat.id,
        participantName: oldChat.participantName,
        participantId: oldChat.participantId,
        lastMessage: content,
        lastMessageTime: 'Now',
        unreadCount: 0,
        participantRole: oldChat.participantRole,
      );
    }
  }

  @override
  Future<List<ChatParticipant>> getAvailableParticipants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockParticipants;
  }
}
