class Contact {
  int id;
  String? name;
  String? imgUrl;
  String? lastMessage;
  String? lastMessageTime;

  Contact(
      {required this.id,
      this.name,
      this.imgUrl,
      this.lastMessage,
      this.lastMessageTime});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        imgUrl: json["imgUrl"],
        lastMessage: json["lastMessage"],
        lastMessageTime: json["lastMessageTime"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imgUrl': imgUrl,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime
      };
}
