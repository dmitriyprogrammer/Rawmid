class SernumModel {
  final String id;
  final String serId;
  final String orderId;
  final String model;
  final String image;
  final String name;
  final String color;
  final String category;
  final String sernum;
  final bool commercial;
  final String warranty;
  final String dateOrdered;
  final String dateAdded;
  final String place;

  SernumModel({
    required this.id,
    required this.serId,
    required this.orderId,
    required this.model,
    required this.image,
    required this.name,
    required this.color,
    required this.category,
    required this.sernum,
    required this.commercial,
    required this.warranty,
    required this.dateOrdered,
    required this.dateAdded,
    required this.place,
  });

  factory SernumModel.fromJson(Map<String, dynamic> json) {
    return SernumModel(
      id: json['id'],
      serId: json['sernum_id'],
      orderId: json['order_id'],
      model: json['model'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      category: json['category'] ?? '',
      sernum: json['sernum'] ?? '',
      commercial: json['commercial'] ?? false,
      warranty: json['warranty'] ?? '',
      dateOrdered: json['date_ordered'] ?? '',
      dateAdded: json['date_added'] ?? '',
      place: json['place'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sernum_id': serId,
      'order_id': orderId,
      'model': model,
      'image': image,
      'name': name,
      'color': color,
      'category': category,
      'sernum': sernum,
      'commercial': commercial,
      'warranty': warranty,
      'date_ordered': dateOrdered,
      'date_added': dateAdded,
      'place': place,
    };
  }
}