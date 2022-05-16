import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streaming/constants.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';

class ChatCard extends StatelessWidget {
  final CustomUser endUser;
  final ChatRoom chatRoom;
  const ChatCard({Key? key, required this.endUser, required this.chatRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          Navigator.of(context).pushNamed("/chat_room",
              arguments: {"chatRoom": chatRoom, "endUser": endUser});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        imageUrl: endUser.photoUrl ?? "",
                        progressIndicatorBuilder:
                            (context, url, downloadProgrees) =>
                                const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "${endUser.displayName}",
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "${chatRoom.lastMessage?.text}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Text(
                      dateFormatter(
                          chatRoom.lastMessage?.sentAt.toString() ?? ""),
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
