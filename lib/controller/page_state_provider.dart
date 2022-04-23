import 'package:flutter/cupertino.dart';
import 'package:streaming/models/enums.dart';

class PageStateProvider extends ChangeNotifier {
  late PageState _currState;
  PageState get currState => _currState;

  late TextEditingController _statusController;
  TextEditingController get statusController => _statusController;

  PageStateProvider() {
    _statusController = TextEditingController();
    _currState = PageState.static;
  }

  void changeState(PageState newState) {
    _currState = newState;
    notifyListeners();
  }
}
