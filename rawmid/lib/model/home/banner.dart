class BannerModel {
  late String title;
  late String image;
  late String image2;
  DateTime? promotionStart;
  DateTime? promotionEnd;
  late String link;

  BannerModel({required this.title, required this.image, required this.image2, required this.link, this.promotionStart, this.promotionEnd});

  BannerModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    image2 = json['image2'];
    promotionEnd = DateTime.tryParse('${json['promotion_end']}');
    promotionStart = DateTime.tryParse('${json['promotion_start']}');
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['image2'] = image2;
    data['promotion_start'] = promotionStart;
    data['promotion_end'] = promotionEnd;
    data['link'] = link;
    return data;
  }
}