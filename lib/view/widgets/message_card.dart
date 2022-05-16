import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:streaming/constants.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/message.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(
      {Key? key,
      required this.context,
      required this.msg,
      required this.byMe,
      required this.size,
      required this.roomId})
      : super(key: key);

  final BuildContext context;
  final Message msg;
  final bool byMe;
  final String roomId;
  final Size size;

  @override
  Widget build(BuildContext context) {
    if (byMe) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(
                minWidth: size.width * 0.3, maxWidth: size.width * 0.5),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: kTextContainerMe,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )),
            // message content //
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    msg.text,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(msg.status,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 13.0, fontWeight: FontWeight.w400)),
                      const SizedBox(
                        width: 2.0,
                      ),
                      msg.sentAt is DateTime
                          ? Text(
                              dateFormatter(msg.sentAt.toString()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 12),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

      /// end user container
    } else {
      context
          .read<ChatRoomProvider>()
          .updateMessageStatus(msg: msg, roomId: roomId);
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(
                minWidth: size.width * 0.2, maxWidth: size.width * 0.5),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: kTextContainerOthers,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            // message content //
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    msg.text,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: msg.sentAt is DateTime
                      ? Text(
                          dateFormatter(msg.sentAt.toString()),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 12),
                        )
                      : Container(),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
