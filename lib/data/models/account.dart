class Account {
  final String username;
  final Uri profilePicUrl;
  final bool isPrivate;
  final String pk;
  final String fullName;
  final bool isVerified;
  final bool hasAnonymousProfilePicture;
  final bool isNew;
  final int lastTimeUpdated;

  Account(
      {required this.username,
      required this.profilePicUrl,
      required this.isPrivate,
      required this.pk,
      required this.fullName,
      required this.isVerified,
      required this.hasAnonymousProfilePicture,
      required this.isNew,
      required this.lastTimeUpdated});

  @override
  bool operator == (Object other) {
    return other is Account && other.username == username;
  }

  factory Account.fromApi(Map<String, dynamic> inputJson) {
    return Account(
        username: inputJson['username'] as String,
        profilePicUrl: Uri.parse(inputJson['profile_pic_url']),
        isPrivate: inputJson['is_private'] as bool,
        pk: inputJson['pk'] as String,
        fullName: inputJson['full_name'] as String,
        isVerified: inputJson['is_verified'] as bool,
        hasAnonymousProfilePicture: inputJson['has_anonymous_profile_picture'] as bool,
        isNew: false,
        lastTimeUpdated: DateTime.now().microsecondsSinceEpoch);
  }

  factory Account.fromSharedPrefs(Map<String, dynamic> inputJson) {
    return Account(
        username: inputJson['userName'] as String,
        profilePicUrl: Uri.parse(inputJson['profilePicUrl']),
        isPrivate: inputJson['isPrivate'] == 'true'? true : false,
        pk: inputJson['pk'] as String,
        fullName: inputJson['fullName'] as String,
        isVerified: inputJson['isVerified'] == 'true'? true : false,
        hasAnonymousProfilePicture: inputJson['hasAnonymousProfilePicture'] == 'true'? true : false,
        isNew: false,
        lastTimeUpdated: int.parse(inputJson['lastTimeUpdated']));
  }

  @override
  String toString() {
    return 'name: $username, fullName: $fullName, isPrivate: $isPrivate';
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": this.username,
      "profilePicUrl": this.profilePicUrl.toString(),
      "isPrivate": this.isPrivate.toString(),
      "pk": this.pk,
      "fullName": this.fullName,
      "isVerified": this.isVerified.toString(),
      "hasAnonymousProfilePicture": this.hasAnonymousProfilePicture.toString(),
      "isNew": this.isNew.toString(),
      "lastTimeUpdated": this.lastTimeUpdated.toString()
    };
  }
}
