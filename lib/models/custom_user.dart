class CustomUser {
  CustomUser({required this.uid, this.email, this.photoUrl, this.displayName});

  String uid;
  String? email;
  String? photoUrl;
  String? displayName;

  factory CustomUser.fromJson(Map<String, dynamic> json) => CustomUser(
      uid: json["uid"],
      email: json["email"],
      photoUrl: json["photoUrl"],
      displayName: json["displayName"]);

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName,
    };
  }
}
