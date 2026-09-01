import 'package:flutter/foundation.dart';

class ConversationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _conversations = [];
  Map<String, dynamic>? _currentConversation;
  List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get conversations => _conversations;
  Map<String, dynamic>? get currentConversation => _currentConversation;
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> fetchConversations() async {
    try {
      // TODO: Call API to fetch conversations
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createConversation(String targetUserId, String myLanguage, String theirLanguage) async {
    try {
      // TODO: Call API to create conversation
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    try {
      // TODO: Call API to fetch messages
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(String conversationId, String text, String language) async {
    try {
      // TODO: Call API to send message
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
