class ProgressModel {
  late int percent;
  late int current;
  late int max;

  ProgressModel({required this.percent, required this.current, required this.max});

  ProgressModel.fromJson(Map<String, dynamic> json) {
    percent = int.tryParse('${json['percent']}') ?? 0;
    current = int.tryParse('${json['current']}') ?? 0;
    max = int.tryParse('${json['max']}') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percent'] = percent;
    data['current'] = current;
    data['max'] = max;
    return data;
  }
}