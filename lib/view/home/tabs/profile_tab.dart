// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streaming/controller/page_state_provider.dart';
import 'package:streaming/controller/user_provider.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({Key? key}) : super(key: key);

  /// VARIABLES ///
  FocusNode focusNode = FocusNode();

  /// TREE ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<UserProvider?>(builder: (_, notifier, __) {
      // call this function to see the changes in the stream.
      notifier?.getCurrentUser();
      CustomUser? user = notifier?.user;
      if (user != null && notifier?.currentState == DataState.done) {
        return buildUserProfile(context, size, user);
      } else if (user == null && notifier?.currentState == DataState.waiting) {
        return buildLoadingWidget();
      } else {
        return Container();
      }
    });
  }

  /// WIDGETS ///
  GestureDetector buildUserProfile(
      BuildContext context, Size size, CustomUser user) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You",
                style: Theme.of(context).textTheme.headline1,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: SizedBox(
                  height: size.height * 0.25,
                  width: size.height * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: user.photoUrl ?? "",
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Flexible(
                child: Align(
                    alignment: AlignmentDirectional.center,
                    child: RichText(
                      text: TextSpan(
                          text: "${user.displayName}",
                          style: Theme.of(context).textTheme.headline3,
                          children: <TextSpan>[
                            TextSpan(
                                text: user.tag,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                        color: Theme.of(context).hintColor))
                          ]),
                    )),
              ),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Consumer<PageStateProvider>(
                      builder: (context, pState, _) {
                    return AnimatedSwitcher(
                        transitionBuilder: ((child, animation) =>
                            ScaleTransition(scale: animation, child: child)),
                        duration: const Duration(milliseconds: 300),
                        child: buildStatusWidget(context, user, size, pState));
                  }),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Divider(
                endIndent: 20.0,
                indent: 20.0,
                color: Theme.of(context).dividerColor,
                thickness: 1.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.email_outlined),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "${user.email}",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusWidget(BuildContext context, CustomUser user, Size size,
      PageStateProvider pState) {
    PageState state = pState.currState;
    switch (state) {
      case PageState.static:
        return Row(
          key: const Key('1'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                width: size.width * .75,
                child: Text(
                  user.status,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColorLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );

      case PageState.editing:
        return Row(
          key: const Key('2'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: SizedBox(
                width: size.width * 0.75,
                child: profileStatusTextField(
                    context, user, focusNode, pState.statusController),
              ),
            ),
          ],
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.status, style: Theme.of(context).textTheme.bodyText2),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined))
          ],
        );
    }
  }

  TextFormField profileStatusTextField(BuildContext context, CustomUser user,
      FocusNode focusNode, TextEditingController textController) {
    return TextFormField(
      focusNode: focusNode,
      controller: textController,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).hintColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary)),
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        hintText: user.status,
      ),
    );
  }

  Widget buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
