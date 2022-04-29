// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/controller/user_provider.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<UserProvider?, FriendProvider?>(
          builder: (_, userNotifier, friendNotifier, __) {
        friendNotifier?.getFriends();
        final users = userNotifier?.usersList;
        return ListView.separated(
            itemCount: users?.length ?? 00,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: ((context, index) {
              bool exists = users?[index].existsInFriends ?? false;
              return ListTile(
                isThreeLine: true,
                onTap: (() {}),
                trailing: IconButton(
                    onPressed: !exists
                        ? () async {
                            if (users != null) {
                              await friendNotifier?.addFriend(users[index]);
                            }
                          }
                        : null,
                    icon: Icon(
                      Icons.check_circle,
                      color: exists
                          ? Colors.grey
                          : Theme.of(context).colorScheme.secondary,
                    )),
                title: Text(
                  "${users?[index].displayName}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                subtitle: Text(
                    "${users?[index].status}" +
                        "\n is in contact? ${users?[index].existsInFriends}",
                    style: Theme.of(context).textTheme.bodyText1),
              );
            }));
      }),
    );
  }
}
