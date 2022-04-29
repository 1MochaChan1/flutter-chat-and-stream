import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Consumer<FriendProvider>(
            builder: ((_, notifier, __) {
              notifier.getFriendRequests();
              return ListView.builder(
                  itemCount: notifier.requests.length,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      title: Text("Some Title"),
                    );
                  });
            }),
          )),
    );
  }
}
