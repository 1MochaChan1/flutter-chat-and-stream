// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/constants.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/chatroom_service.dart';
import 'package:streaming/services/database/database_service.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoom chatRoom;
  CustomUser endUser;

  /// CONSTRUCTOR ///
  ChatRoomScreen({Key? key, required this.chatRoom, required this.endUser})
      : super(key: key);

  /// DECLARATIONS ///
  // final msg = DummyData().messages.reversed.toList();
  CustomUser currentUser = DatabaseService.user;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  /// TREE ///
  @override
  Widget build(BuildContext context) {
    context.read<ChatRoomProvider>().listenToStream(roomId: chatRoom.roomId);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: chatRoomAppBar(context, size),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Flexible(
            child: Consumer<ChatRoomProvider>(builder: (_, notifier, __) {
              notifier.getMessages();
              final msg = notifier.messages;
              return SizedBox(
                height: size.height,
                child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: msg.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      bool byMe = msg[index].sentBy == currentUser.uid;
                      return buildTextContainer(
                          context, msg[index], byMe, size);
                    })),
              );
            }),
          ),
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                width: size.width * 0.95,
                child: Row(
                  children: [
                    Flexible(
                      child: Scrollbar(
                        child: MessageTextField(
                            messageController: messageController),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: InkWell(
                        onTap: () {
                          final msg = Message(
                              sentAt: FieldValue.serverTimestamp(),
                              text: messageController.text.trim(),
                              sentBy: currentUser.uid);
                          context
                              .read<ChatRoomProvider>()
                              .sendMessage(msg: msg, roomId: chatRoom.roomId);
                          messageController.clear();
                        },
                        borderRadius: BorderRadius.circular(30.0),
                        child: const ClipRRect(
                          child: Icon(Icons.send),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ]),
      ),
    );
  }

  /// WIDGETS ///
  AppBar chatRoomAppBar(BuildContext context, Size size) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      leadingWidth: 0.0,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.call))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        )
      ],
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.05,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              imageUrl: endUser.photoUrl ?? "",
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error_outline),
            ),
          ),
          SizedBox(
            width: size.width * 0.05,
          ),
          Flexible(
            flex: 5,
            child: Text(
              endUser.displayName ?? "",
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextContainer(
      BuildContext context, Message msg, bool byMe, Size size) {
    if (byMe) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: size.width * 0.5,
            decoration: BoxDecoration(
                color: kTextContainerMe,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            child: Text(
              msg.text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: size.width * 0.5,
            decoration: BoxDecoration(
                color: kTextContainerOthers,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Text(
              msg.text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      );
    }
  }
}

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key? key,
    required this.messageController,
  }) : super(key: key);

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: 5, // when user presses enter it will adapt to it
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.0))),
      controller: messageController,
    );
  }
}
