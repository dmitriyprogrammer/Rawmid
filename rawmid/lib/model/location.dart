class Location {
  final String label;
  final String value;
  final String fiasId;

  Location({required this.label, required this.value, required this.fiasId});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      label: json['label'],
      value: json['value'],
      fiasId: json['fias_id']
    );
  }
}