import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/controller/user_provider.dart';

class InitProviders {
  static init(BuildContext context) {
    context.read<UserProvider>().listenToStream();
    context.read<FriendProvider>().listenToStream();
    context.read<FriendProvider>().getFriends();
    context.read<ChatRoomProvider>().listenToStream();
    context.read<ChatRoomProvider>().getChatRooms();
  }

  static cleanup(BuildContext context) {
    context.read<UserProvider>().cleanupStream();
    context.read<FriendProvider>().cleanupStream();
    context.read<ChatRoomProvider>().cleanupStream();
  }
}
