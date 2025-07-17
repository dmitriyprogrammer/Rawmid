import 'package:rawmid/model/club/progress.dart';

class AchievementModel {
  late String title;
  late String image;
  late List<String> text;
  late String h6;
  late int reward;
  ProgressModel? progress;

  AchievementModel({required this.title, required this.image, required this.reward, required this.text, required this.h6, required this.progress});

  AchievementModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    text = json['description'] != null ? json['description'].cast<String>() : [];
    h6 = json['h6'];
    reward = int.tryParse('${json['reward']}') ?? 0;
    progress = json['progress'] != null ? ProgressModel.fromJson(json['progress']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['h6'] = h6;
    data['reward'] = reward;
    data['progress'] = progress;
    return data;
  }
}

