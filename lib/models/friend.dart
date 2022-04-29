class Friend {
  int id;
  String? name;
  String? imgUrl;
  String? lastMessage;
  String? lastMessageTime;

  Friend(
      {required this.id,
      this.name,
      this.imgUrl,
      this.lastMessage,
      this.lastMessageTime});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
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
