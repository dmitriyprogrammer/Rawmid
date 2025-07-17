class QuestionModel {
  late String id;
  late String author;
  late String text;
  late int rating;
  late DateTime date;
  late List<QuestionModel> comments;
  late bool parent;
  bool checked = false;

  QuestionModel({required this.id, required this.author, required this.text, required this.rating, required this.date, required this.comments, required this.parent});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    text = json['text'];
    rating = json['rating'];
    comments = <QuestionModel>[];
    if (json['comments'] != null) {
      for (var i in json['comments']) {
        comments.add(QuestionModel.fromJson(i));
      }
    }
    parent = json['parent'];
    date = DateTime.parse('${json['date_added']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['author'] = author;
    data['text'] = text;
    data['rating'] = rating;
    data['comments'] = comments;
    data['parent'] = parent;
    data['date'] = date;
    return data;
  }
}