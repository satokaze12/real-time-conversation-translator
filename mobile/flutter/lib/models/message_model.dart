class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String originalText;
  final String translatedText;
  final String originalLanguage;
  final String translatedLanguage;
  final String messageType; // 'text' or 'audio'
  final String? audioUrl;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.originalText,
    required this.translatedText,
    required this.originalLanguage,
    required this.translatedLanguage,
    required this.messageType,
    this.audioUrl,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      originalText: json['originalText'] as String,
      translatedText: json['translatedText'] as String,
      originalLanguage: json['originalLanguage'] as String,
      translatedLanguage: json['translatedLanguage'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      audioUrl: json['audioUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'originalText': originalText,
      'translatedText': translatedText,
      'originalLanguage': originalLanguage,
      'translatedLanguage': translatedLanguage,
      'messageType': messageType,
      'audioUrl': audioUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
