import 'package:rawmid/model/club/achievement.dart';

class AchievimentModel {
  late String name;
  int rang = 0;
  late int max;
  late List<AchievementModel> achievements;
  late List<AchievementModel> notAchievements;

  AchievimentModel({required this.name, required this.rang, required this.max, required this.achievements, required this.notAchievements});

  AchievimentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rang = json['rang'];
    max = json['max'];

    var items = <AchievementModel>[];

    if (json['achievements'] != null) {
      for (var i in json['achievements']) {
        items.add(AchievementModel.fromJson(i));
      }
    }

    achievements = items;

    items = <AchievementModel>[];

    if (json['not_achievements'] != null) {
      for (var i in json['not_achievements']) {
        items.add(AchievementModel.fromJson(i));
      }
    }

    notAchievements = items;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['rang'] = rang;
    data['max'] = max;
    data['achievements'] = achievements;
    return data;
  }
}