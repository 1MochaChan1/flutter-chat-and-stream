import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/controller/user_provider.dart';
import 'package:streaming/models/enums.dart';

class EditMenuButton extends StatelessWidget {
  const EditMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusController = context.read<PageStateProvider>().statusController;
    return Consumer<PageStateProvider>(
      builder: (_, state, __) {
        switch (state.currState) {
          case PageState.static:
            return IconButton(
                color: Theme.of(context).iconTheme.color,
                onPressed: () => state.changeState(PageState.editing),
                icon: const Icon(Icons.edit_outlined));
          case PageState.editing:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: IconButton(
                      color: Theme.of(context).iconTheme.color,
                      onPressed: () async {
                        Provider.of<UserProvider>(context, listen: false)
                            .updateCurrUser(status: statusController.text)
                            .then(
                                (value) => state.changeState(PageState.static));
                        statusController.clear();
                      },
                      icon: const Icon(Icons.check)),
                ),
                Flexible(
                  child: IconButton(
                      color: Theme.of(context).iconTheme.color,
                      onPressed: () {
                        statusController.clear();
                        state.changeState(PageState.static);
                      },
                      icon: const Icon(Icons.clear)),
                ),
              ],
            );
          default:
            return IconButton(
                color: Theme.of(context).iconTheme.color,
                onPressed: () => state.changeState(PageState.editing),
                icon: const Icon(Icons.edit_outlined));
        }
      },
    );
  }
}
