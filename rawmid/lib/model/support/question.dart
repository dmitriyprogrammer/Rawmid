class QuestionAnswerModel {
  late String question;
  late String answer;

  QuestionAnswerModel({required this.question, required this.answer});

  QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }
}