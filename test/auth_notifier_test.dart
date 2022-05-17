import 'package:mocktail/mocktail.dart';
import 'package:streaming/controller/auth_provider.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/auth_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthProvider sut;
  late MockAuthService service;

  const regEmail = "email123@gmail.com";
  const regPassword = "password12345!";

  _createNewUser({required String email, required String password}) async {
    when(() => service.testCreateNewUser(email: email, password: password))
        .thenAnswer((_) async {
      if (email.length < 5) {
        return AuthState.noUserFound;
      } else if (password.length < 5) {
        return AuthState.wrongPassword;
      }
      return AuthState.success;
    });
  }

  _signInWithNewUser({required String email, required String password}) async {
    when(() => service.testEmailSignIn(email: email, password: password))
        .thenAnswer((_) async {
      if (email != regEmail) {
        return {"user": null, "response": AuthState.noUserFound};
      } else if (password != regPassword) {
        return {"user": null, "response": AuthState.wrongPassword};
      }
      return {"user": CustomUser(uid: "someId"), "response": AuthState.success};
    });
  }

  setUp(() {
    service = MockAuthService();
    sut = AuthProvider(service);
  });

  group("testing for user login/logout auth", () {
    test("""Initial values are correct""", () {
      expect(sut.currentState, DataState.done);
      expect(sut.currentUser, null);
    });

    test("""
    1. Method called when sign up (stream)
    2. Loading start
    3. after getting dataState
    4. Loading stop
    """, () async {
      // arrange
      _createNewUser(email: regEmail, password: regPassword);

      // act
      final future = sut.createNewUser(email: regEmail, password: regPassword);
      expect(sut.currentState, DataState.waiting);
      await future;
      expect(sut.currentState, DataState.done);

      // assert
      verify(() =>
              service.testCreateNewUser(email: regEmail, password: regPassword))
          .called(1);
    });
  });

  test("on signin logic test", () async {
    // arrange
    const signInEmail = "email123@gmail.com";
    const signInPassword = "password12345!";
    _signInWithNewUser(email: signInEmail, password: signInPassword);

    // act
    final future =
        sut.emailSignIn(email: signInEmail, password: signInPassword);
    expect(sut.currentState, DataState.waiting);
    await future;

    // assert
    expect(sut.currentUser, CustomUser(uid: "someID"));
    expect(sut.currentState, DataState.done);
    verify(() => service.testEmailSignIn(
        email: signInEmail, password: signInPassword)).called(1);
  });
}
