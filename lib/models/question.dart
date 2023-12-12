class Question {
  String id;
  final String questionText;
  final String correctAnswer;
  String? imageContent;
  String? type;
  final List<String> options;

  Question({
    required this.id,
    required this.questionText,
    required this.correctAnswer,
    this.imageContent = "",
    this.type = "text",
    this.options = const [],
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      questionText: json['questionText'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      imageContent: json['imageContent'],
      type: json['type'],
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'correctAnswer': correctAnswer,
      'imageContent': imageContent,
      'type': type,
      'options': options,
    };
  }
}