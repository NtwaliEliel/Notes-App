class Note {
  final String id;
  final String text;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap(String userId) {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
