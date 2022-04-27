class CustomUser {
  CustomUser(
      {required this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.rooms,
      this.status = "Something interesting...",
      this.existsInContact = false});

  String uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String status;
  Map<String, bool>? rooms;
  bool existsInContact;

  factory CustomUser.fromJson(
          {required Map<String, dynamic> json, bool? exists}) =>
      CustomUser(
          uid: json["uid"],
          email: json["email"],
          photoUrl: json["photoUrl"],
          displayName: json["displayName"],
          status: json["status"] ?? "Something Interesting..",
          rooms: json["rooms"],
          existsInContact: exists ?? false);

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "displayName": displayName,
      "status": status,
      "rooms": rooms
    };
  }
}
