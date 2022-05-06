// ignore_for_file: unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/view/widgets/friend_request_tile.dart';
import 'package:streaming/view/widgets/loading_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
          height: size.height,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: Consumer<FriendProvider?>(
                  builder: ((_, notifier, __) {
                    final requests = notifier?.requests;
                    notifier?.getFriendRequests();
                    if (notifier?.currentState == DataState.waiting) {
                      return loadingWidget();
                    } else if (notifier?.currentState == DataState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: requests?.length,
                          itemBuilder: (context, index) {
                            return FriendRequestTile(
                                reqSender: requests![index]!,
                                onPressed: () async {
                                  await notifier?.addFriend(requests[index]!);
                                });
                          });
                    } else {
                      return Container();
                    }
                  }),
                ),
              ),
            ],
          )),
    );
  }
}
