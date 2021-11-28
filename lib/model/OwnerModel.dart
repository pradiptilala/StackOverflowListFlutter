class Owner {
  late int accountId;
  late int reputation;
  late int userId;
  late String userType;
  late String profileImage;
  late String displayName;
  late String link;
  int? acceptRate;

  Owner(
      this.accountId,
      this.reputation,
      this.userId,
      this.userType,
      this.profileImage,
      this.displayName,
      this.link,
      this.acceptRate);

  Owner.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    reputation = json['reputation'];
    userId = json['user_id'];
    userType = json['user_type'];
    profileImage = json['profile_image'];
    displayName = json['display_name'];
    link = json['link'];
    acceptRate = json['accept_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['reputation'] = this.reputation;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['profile_image'] = this.profileImage;
    data['display_name'] = this.displayName;
    data['link'] = this.link;
    data['accept_rate'] = this.acceptRate;
    return data;
  }
}

