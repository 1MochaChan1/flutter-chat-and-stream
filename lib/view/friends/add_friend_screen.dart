import 'package:flutter/material.dart';
import 'package:streaming/services/database/friend_service.dart';
import 'package:streaming/view/widgets/search_field.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(children: [
          CustomSearchField(
            controller: _searchController,
            leadingIcon: Icons.search,
            hintText: "Search...",
            trailingIcon: ElevatedButton(
                onPressed: () {
                  FriendService().sendRequest(_searchController.text.trim());
                },
                child: const Text("add")),
          )
        ]),
      )),
    );
  }
}
