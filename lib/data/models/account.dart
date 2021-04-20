class Account {
  final String username;
  final Uri profilePicUrl;
  final String savedProfilePic;
  final bool isPrivate;
  final String pk;
  final String fullName;
  final bool isVerified;
  final bool hasAnonymousProfilePicture;
  bool isChanged;
  final int lastTimeUpdated;

  Account(
      {required this.username,
      required this.profilePicUrl,
      required this.savedProfilePic,
      required this.isPrivate,
      required this.pk,
      required this.fullName,
      required this.isVerified,
      required this.hasAnonymousProfilePicture,
      required this.isChanged,
      required this.lastTimeUpdated});

  @override
  bool operator ==(Object other) {
    return other is Account && other.username == username;
  }

  factory Account.fromApi(Map<String, dynamic> inputJson, String stringImage) {
    return Account(
        username: inputJson['username'] as String,
        profilePicUrl: Uri.parse(inputJson['profile_pic_url']),
        savedProfilePic: stringImage,
        //тут храним преобразованную в Uint8List в String картинку
        isPrivate: inputJson['is_private'] as bool,
        pk: inputJson['pk'] as String,
        fullName: inputJson['full_name'] as String,
        isVerified: inputJson['is_verified'] as bool,
        hasAnonymousProfilePicture: inputJson['has_anonymous_profile_picture'] as bool,
        isChanged: false,
        lastTimeUpdated: DateTime.now().microsecondsSinceEpoch);
  }

  factory Account.fromSharedPrefs(Map<String, dynamic> inputJson) {
    return Account(
        username: inputJson['userName'] as String,
        profilePicUrl: Uri.parse(inputJson['profilePicUrl']),
        savedProfilePic: inputJson['savedProfilePic'],
        isPrivate: inputJson['isPrivate'] == 'true' ? true : false,
        pk: inputJson['pk'] as String,
        fullName: inputJson['fullName'] as String,
        isVerified: inputJson['isVerified'] == 'true' ? true : false,
        hasAnonymousProfilePicture: inputJson['hasAnonymousProfilePicture'] == 'true' ? true : false,
        isChanged: inputJson['isChanged'] == 'true' ? true : false,
        lastTimeUpdated: int.parse(inputJson['lastTimeUpdated']));
  }

  @override
  String toString() {
    return 'name: $username, fullName: $fullName, isPrivate: $isPrivate, isChanged: $isChanged';
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": this.username,
      "profilePicUrl": this.profilePicUrl.toString(),
      "savedProfilePic": this.savedProfilePic,
      "isPrivate": this.isPrivate.toString(),
      "pk": this.pk,
      "fullName": this.fullName,
      "isVerified": this.isVerified.toString(),
      "hasAnonymousProfilePicture": this.hasAnonymousProfilePicture.toString(),
      "isChanged": this.isChanged.toString(),
      "lastTimeUpdated": this.lastTimeUpdated.toString()
    };
  }

  void change() {
    isChanged = true;
  }
}
