class AddressModel {
  late int id;
  late String countryId;
  late String zoneId;
  late String address;
  late String city;
  late String postcode;
  late bool def;

  AddressModel({required this.id, required this.countryId, required this.zoneId, required this.address, required this.city, required this.postcode, required this.def});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    countryId = json['country_id'];
    zoneId = json['zone_id'];
    city = json['city'];
    postcode = json['postcode'];
    def = json['def'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['country_id'] = countryId;
    data['zone_id'] = zoneId;
    data['city'] = city;
    data['postcode'] = postcode;
    data['def'] = def;
    return data;
  }
}