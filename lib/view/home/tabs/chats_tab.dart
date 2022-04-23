import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/contact_provider.dart';
import 'package:streaming/view/widgets/contacts_card.dart';

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
      child: Column(
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
            child:
                SizedBox(width: size.width, child: buildSearchField(context)),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(
            child: Consumer<ContactProvider>(builder: (_, notifier, __) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      context.watch<ContactProvider>().contactsList.length,
                  itemBuilder: (context, index) {
                    return ContactCard(contact: notifier.contactsList[index]);
                  });
            }),
          )
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
