import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? msgId;
  dynamic sentAt;
  String text;
  String sentBy;
  String status;

  Message(
      {required this.sentAt,
      required this.text,
      required this.sentBy,
      required this.status,
      this.msgId});

  factory Message.fromJson(Map<String, dynamic> json) {
    var sentAtDateTime = json["sentAt"];
    var status = "";
    if (json["sentAt"] != null) {
      final sentAtTimestamp = json["sentAt"] as Timestamp;
      sentAtDateTime = DateTime.fromMillisecondsSinceEpoch(
          sentAtTimestamp.millisecondsSinceEpoch);
    }

    // if (json["status"] == "pending" /*&& json["sentAt"] != null*/) {
    //   status = "sent";
    // } else {
    //   status = "pending";
    // }

    return Message(
        sentAt: sentAtDateTime,
        text: json["text"],
        sentBy: json["sentBy"],
        status: json["status"],
        msgId: json["msgId"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "sentAt": sentAt,
      "sentBy": sentBy,
      "text": text,
      "msgId": msgId,
      "status": status
    };
  }

  // this is to create an instance that can be local
  // when the user sends message without network.
  Message copyWith({String? status}) {
    return Message(
        msgId: msgId,
        sentAt: sentAt,
        text: text,
        sentBy: sentBy,
        status: status ?? this.status);
  }
}
