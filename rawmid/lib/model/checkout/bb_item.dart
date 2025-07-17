class BBItemModel {
  final String type;
  final String id;
  final double latitude;
  final double longitude;
  final String pvzId;
  final String pvzName;
  final String pvzAddr;
  final String trip;
  final String phone;
  final int cod;
  final bool noKd;
  final String work;
  final String zone;
  final String city;
  final int period;

  BBItemModel({
    required this.type,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.pvzId,
    required this.pvzName,
    required this.pvzAddr,
    required this.trip,
    required this.phone,
    required this.cod,
    required this.noKd,
    required this.work,
    required this.zone,
    required this.city,
    required this.period,
  });

  factory BBItemModel.fromJson(Map<String, dynamic> json) {
    return BBItemModel(
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      latitude: double.parse(json['geometry']['coordinates'][0]),
      longitude: double.parse(json['geometry']['coordinates'][1]),
      pvzId: json['properties']['pvz_id'] ?? '',
      pvzName: json['properties']['pvz_name'] ?? '',
      pvzAddr: json['properties']['pvz_addr'] ?? '',
      trip: json['properties']['trip'] ?? '',
      phone: json['properties']['phone'] ?? '',
      cod: json['properties']['cod'] ?? false,
      noKd: json['properties']['no_kd'] ?? false,
      work: json['properties']['work'] ?? '',
      zone: json['properties']['zone'] ?? '',
      city: json['properties']['city'] ?? '',
      period: int.parse(json['properties']['period'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'geometry': {
        'coordinates': [longitude.toString(), latitude.toString()],
      },
      'properties': {
        'pvz_id': pvzId,
        'pvz_name': pvzName,
        'pvz_addr': pvzAddr,
        'trip': trip,
        'phone': phone,
        'cod': cod,
        'no_kd': noKd,
        'work': work,
        'zone': zone,
        'city': city,
        'period': period,
      }
    };
  }
}