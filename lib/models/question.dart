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
      imageContent: json['imageContent'] ?? '',
      type: json['type'] ?? 'text',
      options:json['options']!=null? List<String>.from(json['options'] ?? []):[],
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
class User {
  final String id;
  final String name;
  final String point;
  final String tt_image;
   String hh;
  User({
    required this.id,
    required this.name,
    required this.point,
    required this.tt_image,
     this.hh= ""
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
     name: json['name']??"",
      point: json['point']??"",
        tt_image:json['tt_image']??"",
      hh:json['hh']??"",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name':name,
      "point":point,
      "tt_image":tt_image,
      "hh":hh
    };
  }
}
class Mes {
  final String idTB;
  final String title;
  final String body;
  final String time;
  final String timeSeen;
  final bool isSeen;

  Mes({required this.title, required this.body, required this.time,required this.isSeen,required this.idTB,required this.timeSeen});

  factory Mes.fromJson(Map<String, dynamic> json) {
    return Mes(
      idTB: json['idTB'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      time:json['time'] ?? '',
      isSeen: json['isSeen'] ?? false,
      timeSeen: json['timeSeen'] ?? '',
    );
  }
}
class Token {
  final String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] ?? '',
    );
  }
}