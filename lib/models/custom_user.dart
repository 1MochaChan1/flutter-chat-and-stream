class CustomUser {
  CustomUser(
      {required this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.status = "Something interesting..."});

  String uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String status;

  factory CustomUser.fromJson(Map<String, dynamic> json) => CustomUser(
      uid: json["uid"],
      email: json["email"],
      photoUrl: json["photoUrl"],
      displayName: json["displayName"],
      status: json["status"]);

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName,
      "status": status
    };
  }
}
