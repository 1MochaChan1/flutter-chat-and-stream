// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/database_service.dart';
import 'package:streaming/view/widgets/message_card.dart';
import 'package:streaming/view/widgets/message_text_field.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoom chatRoom;
  CustomUser endUser;

  /// CONSTRUCTOR ///
  ChatRoomScreen({Key? key, required this.chatRoom, required this.endUser})
      : super(key: key);

  /// DECLARATIONS ///
  CustomUser currentUser = DatabaseService.user;
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  /// TREE ///
  @override
  Widget build(BuildContext context) {
    context.read<ChatRoomProvider>().listenToStream(roomId: chatRoom.roomId);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context.read<ChatRoomProvider>().messages.clear();
        return true;
      },
      child: Scaffold(
        appBar: chatRoomAppBar(context, size),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Flexible(
              child: Consumer<ChatRoomProvider>(builder: (_, notifier, __) {
                notifier.getMessages();
                final messages = notifier.messages;
                return SizedBox(
                  height: size.height,
                  child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messages.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        // checks if we're the sender.
                        bool byMe = messages[index].sentBy == currentUser.uid;
                        return MessageCard(
                            context: context,
                            msg: messages[index],
                            byMe: byMe,
                            roomId: chatRoom.roomId,
                            size: size);
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
                            // we have the status of 'sent' here since
                            // firebase operates when it's offline too.
                            final msg = Message(
                                sentAt: FieldValue.serverTimestamp(),
                                text: messageController.text.trim(),
                                sentBy: currentUser.uid,
                                status: "sent");
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
}
