import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/view/widgets/search_field.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var success = false;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Consumer<FriendProvider?>(builder: (_, notifier, __) {
          return Column(children: [
            CustomSearchField(
              controller: _searchController,
              leadingIcon: Icons.search,
              hintText: "Search...",
              trailingIcon: ElevatedButton(
                  onPressed: () {
                    notifier?.sendFriendRequest(_searchController.text.trim());
                  },
                  child: const Text("Add")),
            )
          ]);
        }),
      )),
    );
  }
}
