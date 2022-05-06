import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/friend_provider.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/view/widgets/search_field.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var success = true;
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
              validCondition: success,
              errorText: "The username or tagged is incorrect.",
              trailingIcon: notifier?.childWidgetState == ChildWidgetState.done
                  ? ElevatedButton(
                      onPressed: () async {
                        // implementing loader.
                        notifier?.setWidgetState(ChildWidgetState.waiting);
                        success = await notifier?.sendFriendRequest(
                                _searchController.text.trim()) ??
                            true;
                        notifier?.setWidgetState(ChildWidgetState.done);

                        if (success) {
                          buildSnackBar(context);
                          _searchController.clear();
                        }
                      },
                      child: const Text("Add"))
                  : const CircularProgressIndicator(),
            )
          ]);
        }),
      )),
    );
  }

  buildSnackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.thumb_up_off_alt_outlined),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              "Request sent successfully",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    ));
  }
}
