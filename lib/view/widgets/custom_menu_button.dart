import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/controller/themes_provider.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:streaming/services/database/database_service.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: Theme.of(context).backgroundColor,
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).iconTheme.color,
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () =>
                      context.read<ThemeProvider>().toggle(CusTheme.Dark),
                  child: Text(
                    "Dark",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16.0),
                  )),
              PopupMenuItem(
                  onTap: () =>
                      context.read<ThemeProvider>().toggle(CusTheme.Light),
                  child: Text(
                    "Light",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16.0),
                  )),
              PopupMenuItem(
                  onTap: () async {
                    context.read<AuthService>().signOut();
                  },
                  child: Text(
                    "Log Out",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16.0),
                  )),
              PopupMenuItem(
                  onTap: () async {
                    context
                        .read<PageStateProvider>()
                        .changeState(PageState.editing);
                  },
                  child: Text(
                    "Edit",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16.0),
                  )),
              PopupMenuItem(
                  onTap: () async {
                    context
                        .read<PageStateProvider>()
                        .changeState(PageState.static);
                  },
                  child: Text(
                    "Static",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 16.0),
                  )),
            ]);
  }
}
