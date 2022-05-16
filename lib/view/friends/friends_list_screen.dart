// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/services/database/chatroom_service.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FriendProvider?>(builder: (_, friendNotifier, __) {
        final friends = friendNotifier?.friends;
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemCount: friends?.length ?? 00,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: ((context, index) {
                    // bool exists = users?[index].existsInFriends ?? false;
                    return ListTile(
                      onTap: (() async {
                        ChatRoomService().createChatRoom(friends![index]!);
                      }),
                      title: Text(
                        "${friends?[index]?.displayName}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  })),
            ),
          ],
        );
      }),
    );
  }
}
