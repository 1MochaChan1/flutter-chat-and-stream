class CustomUser {
  CustomUser(
      {required this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.rooms,
      this.tag = "#0000",
      this.status = "Something interesting...",
      this.existsInFriends = false});

  // existsInContact should not be pushed to DB except for requests.
  // it's for local use and requests only
  String uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String status;
  Map<String, bool>? rooms;
  String tag;
  bool existsInFriends;

  factory CustomUser.fromJson(
          {required Map<String, dynamic> json, bool? exists}) =>
      CustomUser(
          uid: json["uid"],
          email: json["email"] ?? "",
          photoUrl: json["photoUrl"] ?? "",
          displayName: json["displayName"] ?? "",
          status: json["status"] ?? "Something Interesting..",
          // rooms: json["rooms"],
          tag: json["tag"] ?? "",
          existsInFriends: exists ?? json["existsInFriends"] ?? false);

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName,
      "status": status,
      "rooms": rooms,
      // "existsInFriends": existsInFriends,
      "tag": tag
    };
  }
}
