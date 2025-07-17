class Pvz {
  final String code;
  final String name;
  final String cityCode;
  final String city;
  final String workTime;
  final String address;
  final String phone;
  final String note;
  final double coordX;
  final double coordY;
  final String type;
  final String ownerCode;

  Pvz({
    required this.code,
    required this.name,
    required this.cityCode,
    required this.city,
    required this.workTime,
    required this.address,
    required this.phone,
    required this.note,
    required this.coordX,
    required this.coordY,
    required this.type,
    required this.ownerCode,
  });

  factory Pvz.fromJson(Map<String, dynamic> json) {
    return Pvz(
      code: json['Code'],
      name: json['Name'],
      cityCode: json['CityCode'],
      city: json['City'],
      workTime: json['WorkTime'],
      address: json['Address'],
      phone: json['Phone'],
      note: json['Note'],
      coordX: double.tryParse(json['coordX']) ?? 0,
      coordY: double.tryParse(json['coordY']) ?? 0,
      type: json['Type'],
      ownerCode: json['ownerCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Name': name,
      'CityCode': cityCode,
      'City': city,
      'WorkTime': workTime,
      'Address': address,
      'Phone': phone,
      'Note': note,
      'coordX': coordX.toString(),
      'coordY': coordY.toString(),
      'Type': type,
      'ownerCode': ownerCode,
    };
  }
}