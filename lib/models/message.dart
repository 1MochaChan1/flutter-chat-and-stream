import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  dynamic sentAt;
  String text;
  String sentBy;

  Message({required this.sentAt, required this.text, required this.sentBy});

  factory Message.fromJson(Map<String, dynamic> json) {
    var sentAtDateTime = json["sentAt"];
    if (json["sentAt"] != null) {
      final sentAtTimestamp = json["sentAt"] as Timestamp;
      sentAtDateTime = DateTime.fromMillisecondsSinceEpoch(
          sentAtTimestamp.millisecondsSinceEpoch);
    }

    return Message(
        sentAt: sentAtDateTime, text: json["text"], sentBy: json["sentBy"]);
  }

  Map<String, dynamic> toJson() {
    return {"sentAt": sentAt, "sentBy": sentBy, "text": text};
  }
}
