import 'package:get/get.dart';
import 'package:rawmid/api/profile.dart';
import '../model/profile/reward.dart';

class RewardController extends GetxController {
  var isLoading = false.obs;
  var rewards = <String, List<RewardModel>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future initialize() async {
    final api = await ProfileApi.rewards();

    for (var reward in api) {
      if (!rewards.containsKey(reward.date)) {
        rewards[reward.date] = [];
      }

      rewards[reward.date]!.add(reward);
    }

    isLoading.value = true;
  }

  String extractFragment(String input) {
    RegExp regExp = RegExp(r'достижением([^\.]*)\.');
    Match? match = regExp.firstMatch(input);

    if (match != null) {
      return match.group(1)!.trim();
    }

    return '';
  }

  Map<String, List<RewardModel>> groupByDate(List<RewardModel> rewards) {
    final Map<String, List<RewardModel>> grouped = {};

    for (var reward in rewards) {
      if (!grouped.containsKey(reward.date)) {
        grouped[reward.date] = [];
      }

      grouped[reward.date]!.add(reward);
    }

    return grouped;
  }
}