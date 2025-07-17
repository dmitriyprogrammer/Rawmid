class RankModel {
  String? clubRankId;
  String? title;
  String? image;
  String? description;
  String? sortOrder;
  String? rewards;
  String? rewardPercent;
  String? features;

  RankModel(
      {this.clubRankId,
        this.title,
        this.image,
        this.description,
        this.sortOrder,
        this.rewards,
        this.rewardPercent,
        this.features});

  RankModel.fromJson(Map<String, dynamic> json) {
    clubRankId = json['club_rank_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    sortOrder = json['sort_order'];
    rewards = json['value'];
    rewardPercent = json['reward_percent'];
    features = json['features'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['club_rank_id'] = clubRankId;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['sort_order'] = sortOrder;
    data['value'] = rewards;
    data['reward_percent'] = rewardPercent;
    data['features'] = features;
    return data;
  }
}
