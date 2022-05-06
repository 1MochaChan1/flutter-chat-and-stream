import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/view/widgets/chat_card.dart';

// ignore: must_be_immutable
class ChatsTab extends StatelessWidget {
  ChatsTab({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  int bottomNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: 12.0,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: SizedBox(
                    width: size.width, child: buildSearchField(context)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Flexible(
                  child: Consumer<ChatRoomProvider>(builder: (_, notifier, __) {
                final chatrooms = notifier.rooms;
                if (chatrooms.isEmpty) {
                  return const Center(
                    child: Text("Empty"),
                  );
                } else if (notifier.currentState == DataState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatrooms.length,
                      itemBuilder: ((context, index) {
                        final endUser = chatrooms[index]
                            .participents
                            ?.where((element) =>
                                element.uid != notifier.currentUser.uid)
                            .toList()[0];
                        // final otherUser = otherUsers?[0];
                        return ChatCard(
                            endUser: endUser!, chatRoom: chatrooms[index]);
                      }));
                }
              }))
            ],
          ),
          PositionedDirectional(
              bottom: 10.0,
              end: 0.0,
              child: FloatingActionButton(
                elevation: 0.0,
                onPressed: () async {
                  // Navigator.pushNamed(context, "/users");
                  Navigator.pushNamed(context, "/add_friend");
                  // Navigator.pushNamed(context, "/notifs");
                },
                child: const Icon(Icons.add),
              )),
        ],
      ),
    );
  }

  /// WIDGETS ///
  Widget buildSearchField(BuildContext context) {
    return TextField(
      controller: searchController,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).bottomAppBarColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
          hintText: "Search...",
          hintStyle: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
// Consumer<FakeFriendProvider>(builder: (_, notifier, __) {
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: context
//                           .watch<FakeFriendProvider>()
//                           .contactsList
//                           .length,
//                       itemBuilder: (context, index) {
//                         return FriendCard(
//                             contact: notifier.contactsList[index]);
//                       });
//                 })