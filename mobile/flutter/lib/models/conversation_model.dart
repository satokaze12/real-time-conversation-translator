class Conversation {
  final String id;
  final Map<String, dynamic> userA;
  final Map<String, dynamic> userB;
  final String languageA;
  final String languageB;
  final String status; // 'active', 'archived', 'closed'
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userA,
    required this.userB,
    required this.languageA,
    required this.languageB,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      userA: json['userA'] as Map<String, dynamic>,
      userB: json['userB'] as Map<String, dynamic>,
      languageA: json['languageA'] as String,
      languageB: json['languageB'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userA': userA,
      'userB': userB,
      'languageA': languageA,
      'languageB': languageB,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
