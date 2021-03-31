class ApiAccount {
  final String username;
  final String profilePicUrl;
  final bool isPrivate;
  final String pk;
  final String fullName;
  final bool isVerified;
  final bool hasAnonymousProfilePicture;

  ApiAccount.fromApi(Map<String, dynamic> map)
      : this.username = map['username'] as String,
        this.profilePicUrl = map['profile_pic_url'] as String,
        this.isPrivate = map['is_private'] as bool,
        this.pk = map['pk'] as String,
        this.fullName = map['full_name'] as String,
        this.isVerified = map['is_verified'] as bool,
        this.hasAnonymousProfilePicture = map['has_anonymous_profile_picture'] as bool;
}