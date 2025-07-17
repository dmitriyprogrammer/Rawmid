class RewardModel {
  late final String date;
  late final String text;
  late final String reward;

  RewardModel({required this.date, required this.text, required this.reward});

  RewardModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    text = json['text'];
    reward = json['reward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['text'] = text;
    data['reward'] = reward;
    return data;
  }
}