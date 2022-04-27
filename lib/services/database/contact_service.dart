// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/database_service.dart';

class ContactService extends DatabaseService {
  /// DECLARATION ///
  StreamController _contactStreamController = StreamController.broadcast();
  StreamController get contactStreamController => _contactStreamController;
  late StreamSubscription _subscription;
  CustomUser currentUser = DatabaseService.user;

  /// CONSTRUCTOR ///
  ContactService() {
    _subscription = getUserContacts().listen((event) {
      return _contactStreamController.add(event);
    });
  }

  /// METHODS ///
  Stream<List<dynamic>> getUserContacts() async* {
    List<dynamic> contactList = [];
    CollectionReference userContacts =
        contacts.doc(DatabaseService.user.uid).collection("userContacts");

    await for (var rec in userContacts.snapshots()) {
      List varList = [];
      for (var document in rec.docs) {
        final json = document.data() as Map<String, dynamic>;
        final cusUser = CustomUser.fromJson(json: json);
        varList.add(cusUser);
      }
      contactList = varList;
      yield contactList;
    }
  }

  Future<void> addToContact(CustomUser newContact) async {
    try {
      await contacts
          .doc(currentUser.uid)
          .collection("userContacts")
          .doc(newContact.uid)
          .set(newContact.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
