class ApiAccount {
  final String username;
  final String profilePicUrl;
  final String isPrivate;
  final String pk;
  final String fullName;
  final String isVerified;
  final String hasAnonymousProfilePicture;

  ApiAccount.fromApi(Map<String, dynamic> map)
      : this.username = map['username'],
        this.profilePicUrl = map['profile_pic_url'],
        this.isPrivate = map['is_private'],
        this.pk = map['pk'],
        this.fullName = map['full_name'],
        this.isVerified = map['is_verified'],
        this.hasAnonymousProfilePicture = map['has_anonymous_profile_picture'];
}