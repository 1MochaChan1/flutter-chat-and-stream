import 'package:flutter/cupertino.dart';

abstract class CustomChangeNotifier with ChangeNotifier {
  void listenToStream();
  void cleanupStream();
}
