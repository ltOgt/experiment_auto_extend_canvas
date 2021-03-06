import 'package:flutter/foundation.dart';

class StatefulModel extends ChangeNotifier {
  void setState([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}
