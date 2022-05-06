import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/message.dart';

class ChatRoom {
  String roomId;
  List<CustomUser>? participents;
  List<dynamic> participentIds;
  Message? lastMessage;

  ChatRoom(
      {required this.roomId,
      required this.participentIds,
      required this.participents,
      this.lastMessage});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    Message? lastMsg;
    if (json["lastMessage"] != null) {
      lastMsg = Message.fromJson(json["lastMessage"]);
    } else {
      lastMsg = null;
    }

    return ChatRoom(
        roomId: json["roomId"],
        participentIds: json["participentIds"],
        // setting the participents null here
        // it gets set after we get the data.
        participents: [],
        lastMessage: lastMsg);
  }

  setParticipents(List<CustomUser> newParticipents) {
    participents = newParticipents;
  }

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "participentIds": participentIds,
      "participents": participents
    };
  }
}
