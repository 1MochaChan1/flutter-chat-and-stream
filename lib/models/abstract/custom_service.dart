import 'package:flutter/cupertino.dart';

abstract class CustomService with ChangeNotifier {
  void addStream();
  void cleanupStream();
}
