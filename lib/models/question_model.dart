class QuestionModel {
  String? imagePath, correctAnswer, id;
  List<String>? answers;

  QuestionModel({required this.imagePath, required this.answers, required this.id, required this.correctAnswer});

  QuestionModel.fromJson(Map<String, dynamic> map) {
    imagePath = map['img'];
    id = map['id'];
    correctAnswer = map['correct'];
    answers = List<String>.from(
      map["ans"]!.map((x) => x),
    );
  }
}
