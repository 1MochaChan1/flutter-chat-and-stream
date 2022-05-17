import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/chatroom_service.dart';
import 'package:test/test.dart';

class MockChatRoomService extends Mock implements ChatRoomService {}

void main() {
  late ChatRoomProvider sut;
  late MockChatRoomService mockChatRoomService;

  setUp(() {
    mockChatRoomService = MockChatRoomService();
    sut = ChatRoomProvider(service: mockChatRoomService);
  });

  group('get messages', () {
    void getting4MessagesFromTheService() {
      when(() => mockChatRoomService.getTestMessages())
          .thenAnswer((_) async => [
                Message(
                    sentAt: FieldValue.serverTimestamp(),
                    text: "Message 1",
                    sentBy: "TAHh8DJzr7cqnzurYP6CjoYxcq52",
                    status: "sent"),
                Message(
                    sentAt: FieldValue.serverTimestamp(),
                    text: "Message 2",
                    sentBy: "T7aZYlKRQMhmRsgO0IyleJEhq4n1",
                    status: "sent"),
                Message(
                    sentAt: FieldValue.serverTimestamp(),
                    text: "Message 3",
                    sentBy: "TAHh8DJzr7cqnzurYP6CjoYxcq52",
                    status: "sent"),
                Message(
                    sentAt: FieldValue.serverTimestamp(),
                    text: "Message 4",
                    sentBy: "T7aZYlKRQMhmRsgO0IyleJEhq4n1",
                    status: "sent"),
              ]);
    }

    // init test
    test(
        "testing if initial values of the provider are correct"
        "1. _rooms = []"
        "2. _messages = []"
        "3. _currentState = DataState.waiting", () {
      expect(sut.rooms, []);
      expect(sut.messages, []);
      expect(sut.currentState, DataState.waiting);
    });

    // method called test
    test(
        'Calling the getMessages() method on the provider class'
        'checking if it triggers the method from the services.', () async {
      // implementing a fake service method in the service class => arrange
      when(() => mockChatRoomService.getTestMessages())
          .thenAnswer((_) async => []);

      // calling the method via the provider class => act
      await sut.getTestMessages();

      // checking if the method is called at least once in the service class => assert
      verify(() => mockChatRoomService.getTestMessages()).called(1);
    });

    // data received test
    test("""1. indicating loading of data => (DataState.waiting)
    2. store the fetched data => (_message.isEmpty == false)
    3. indicating loading of data has stopped => (DataStat.done)
    """, () async {
      // arrange
      getting4MessagesFromTheService();

      // act
      final future = sut
          .getTestMessages(); // don't await since we need to check inner process
      expect(sut.currentState, DataState.waiting);
      await future;
      expect(sut.messages.isEmpty, false);
      expect(sut.currentState, DataState.done);

      // assert
      verify(
        () => mockChatRoomService.getTestMessages(),
      ).called(1);
    });
  });
}
