import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/fake_contact_provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/view/widgets/friend_card.dart';

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
                child: Consumer2<FakeFriendProvider, FriendProvider>(
                    builder: (_, notifier, notifier2, __) {
                  notifier2.getFriends();
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: context
                          .watch<FakeFriendProvider>()
                          .contactsList
                          .length,
                      itemBuilder: (context, index) {
                        return FriendCard(
                            contact: notifier.contactsList[index]);
                      });
                }),
              )
            ],
          ),
          PositionedDirectional(
              bottom: 10.0,
              end: 0.0,
              child: FloatingActionButton(
                // backgroundColor: ,
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
