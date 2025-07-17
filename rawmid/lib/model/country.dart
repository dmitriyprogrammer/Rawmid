class CountryModel {
  String? countryId;
  String? name;
  String? isoCode2;
  String? isoCode3;
  String? addressFormat;
  String? postcodeRequired;
  List<ZoneModel>? zone;

  CountryModel(
      {this.countryId,
        this.name,
        this.isoCode2,
        this.isoCode3,
        this.addressFormat,
        this.postcodeRequired,
        this.zone});

  CountryModel.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    name = json['name'];
    isoCode2 = json['iso_code_2'];
    isoCode3 = json['iso_code_3'];
    addressFormat = json['address_format'];
    postcodeRequired = json['postcode_required'];
    if (json['zone'] != null) {
      zone = <ZoneModel>[];
      json['zone'].forEach((v) {
        zone!.add(ZoneModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_id'] = countryId;
    data['name'] = name;
    data['iso_code_2'] = isoCode2;
    data['iso_code_3'] = isoCode3;
    data['address_format'] = addressFormat;
    data['postcode_required'] = postcodeRequired;
    if (zone != null) {
      data['zone'] = zone!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZoneModel {
  String? zoneId;
  String? countryId;
  String? name;
  String? code;
  String? status;

  ZoneModel({this.zoneId, this.countryId, this.name, this.code, this.status});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    countryId = json['country_id'];
    name = json['name'];
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_id'] = zoneId;
    data['country_id'] = countryId;
    data['name'] = name;
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}
