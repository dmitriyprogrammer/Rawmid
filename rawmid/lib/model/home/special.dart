class SpecialModel {
  late String id;
  late String title;
  late String image;
  late String text;
  late String link;

  SpecialModel({required this.id, required this.title, required this.image, required this.text, required this.link});

  SpecialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    text = json['text'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['link'] = link;
    return data;
  }
}