import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/database/database_service.dart';

class EditMenuButton extends StatelessWidget {
  EditMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageStateProvider>(
      builder: (_, state, __) {
        switch (state.currState) {
          case PageState.static:
            return IconButton(
                onPressed: () => state.changeState(PageState.editing),
                icon: const Icon(Icons.edit_outlined));
          case PageState.editing:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: IconButton(
                      onPressed: () async {
                        final status = context
                            .read<PageStateProvider>()
                            .statusController
                            .text;
                        context
                            .read<DatabaseService>()
                            .updateUserData(status: status)
                            .then(
                                (value) => state.changeState(PageState.static));
                      },
                      icon: const Icon(Icons.check)),
                ),
                Flexible(
                  child: IconButton(
                      onPressed: () => state.changeState(PageState.static),
                      icon: const Icon(Icons.clear)),
                ),
              ],
            );
          default:
            return IconButton(
                onPressed: () => state.changeState(PageState.editing),
                icon: const Icon(Icons.edit_outlined));
        }
      },
    );
  }
}
