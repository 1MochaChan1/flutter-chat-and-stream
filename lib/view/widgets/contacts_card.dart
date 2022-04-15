import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streaming/models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        imageUrl: contact.imgUrl ?? "",
                        progressIndicatorBuilder:
                            (context, url, downloadProgrees) =>
                                const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "${contact.name}",
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "${contact.lastMessage}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 10.0, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Text(
                      DateFormat().add_jm().format(DateTime.now()),
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String dateFormatter(String dateStr) {
    String date = "";
    if (contact.lastMessageTime != null) {
      date = DateFormat().add_jm().format(DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(contact.lastMessageTime ?? ""));
    }
    return date;
  }
}
