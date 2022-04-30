// ignore_for_file: prefer_adjacent_string_concatenation, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:streaming/models/custom_user.dart';

class FriendRequestTile extends StatefulWidget {
  final CustomUser reqSender;
  final Function onPressed;
  const FriendRequestTile(
      {Key? key, required this.reqSender, required this.onPressed})
      : super(key: key);

  @override
  State<FriendRequestTile> createState() => _FriendRequestTileState();
}

class _FriendRequestTileState extends State<FriendRequestTile> {
  ValueNotifier<bool> loadCurrentTile = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    CustomUser reqSender = widget.reqSender;
    return ValueListenableBuilder(
        valueListenable: loadCurrentTile,
        builder: (context, value, _) {
          return ListTile(
            isThreeLine: true,
            onTap: (() {}),
            trailing: loadCurrentTile.value
                ? const CircularProgressIndicator()
                : IconButton(
                    onPressed: !reqSender.existsInFriends
                        ? () async {
                            loadCurrentTile.value = true;
                            await widget.onPressed();
                            loadCurrentTile.value = false;
                          }
                        : null,
                    icon: Icon(
                      Icons.check_circle,
                      color: reqSender.existsInFriends
                          ? Colors.grey
                          : Theme.of(context).colorScheme.secondary,
                    )),
            title: Text(
              "${reqSender.displayName}",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            subtitle: Text("Wants to be your friend.",
                style: Theme.of(context).textTheme.bodyText1),
          );
        });
  }
}
