class BbLocationModel {
  final String city;
  final int zoneId;
  final String address;

  BbLocationModel({
    required this.city,
    required this.zoneId,
    required this.address
  });

  factory BbLocationModel.fromJson(Map<String, dynamic> json) {
    return BbLocationModel(
      city: json['city'],
      zoneId: int.tryParse('${json['zone_id']}') ?? 0,
      address: json['addr1']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'zone_id': zoneId,
      'addr1': address
    };
  }
}