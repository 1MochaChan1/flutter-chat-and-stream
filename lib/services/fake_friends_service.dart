// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:streaming/models/friend.dart';

class FakeFriendService {
  List<Friend> friendsList = [
    Friend(
        id: 1,
        name: "Dan",
        imgUrl:
            "https://qaprovider.com/storage/users/2773_avatar1588529274.png",
        lastMessage: "Bye",
        lastMessageTime: "2019-07-19 8:40:23"),
    Friend(
        id: 2,
        name: "Sam",
        imgUrl: "https://w7.pngwing.com/pngs/340/946/" +
            "png-transparent-avatar-user-computer-icons-software-developer" +
            "-avatar-child-face-heroes-thumbnail.png",
        lastMessage: "Hey",
        lastMessageTime: "2019-07-19 11:12:23"),
    Friend(
        id: 3,
        name: "Yeh",
        imgUrl: "http://happyfacesparty.com/wp-content/" +
            "uploads/2019/06/avataaars-Frances.png",
        lastMessage: "Hey",
        lastMessageTime: "2019-07-19 1:40:00"),
  ];

  List<Friend> getContacts() {
    return friendsList;
  }

  bool addContacts(Friend contact) {
    friendsList.add(contact);
    return true;
  }
}
