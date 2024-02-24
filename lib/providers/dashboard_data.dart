import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DashboardNotifier extends ChangeNotifier {
  bool _needsUpdate = false;

  bool get needsUpdate => _needsUpdate;

  void updateDashboard() {
    _needsUpdate = true;
    notifyListeners();
  }

  void resetNeedsUpdate() {
    _needsUpdate = false;
  }
}
