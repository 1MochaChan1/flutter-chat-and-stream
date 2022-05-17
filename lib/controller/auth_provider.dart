// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:streaming/models/abstract/custom_change_notifier.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/auth_service.dart';

class AuthProvider extends CustomChangeNotifier {
  final AuthService _service;

  // only for testing //
  User? _currentUser;
  User? get currentUser => _currentUser;

  late DataState _currentState = DataState.done;
  DataState get currentState => _currentState;

  AuthProvider(this._service) {
    _currentState = DataState.done;
  }

  @override
  void cleanupStream() async {
    await _service.cleanupStream();
  }

  @override
  void listenToStream() {
    _service.addStream();
  }

  onAuthStateChange() {
    _service.authStateStreamController.stream.listen((event) {
      _currentUser = event;
      notifyListeners();
    });
  }

  notify() {
    notifyListeners();
  }

  Future<CustomUser?> googleSignIn() async {
    try {
      final currUser = await _service.googleSignIn();
      notifyListeners();
      return currUser;
    } catch (e) {
      rethrow;
    }
  }

  signOut() async {
    try {
      await _service.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// UNDER TESTING ///
  Future<Map<String, dynamic>> emailSignIn(
      {required String email, required String password}) async {
    _currentState = DataState.waiting;
    notifyListeners();
    try {
      final response =
          await _service.testEmailSignIn(email: email, password: password);
      _currentUser = response["user"];
      _currentState = DataState.done;
      notifyListeners();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthState> createNewUser(
      {required String email, required String password}) async {
    try {
      // final state =
      //     await _service.createNewUser(email: email, password: password);
      _currentState = DataState.waiting;
      notifyListeners();
      final state =
          await _service.testCreateNewUser(email: email, password: password);
      _currentState = DataState.done;
      notifyListeners();
      return state;
    } catch (e) {
      rethrow;
    }
  }
}
