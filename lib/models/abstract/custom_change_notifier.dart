import 'package:flutter/cupertino.dart';

abstract class CustomChangeNotifier extends ChangeNotifier {
  void listenToStream();
  void cleanupStream();
}
