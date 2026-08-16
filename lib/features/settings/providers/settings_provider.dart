import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _pushNotifications = true;
  bool _emailPromotions = true;
  String _selectedCurrency = 'USD (\$)';

  bool get pushNotifications => _pushNotifications;
  bool get emailPromotions => _emailPromotions;
  String get selectedCurrency => _selectedCurrency;

  void togglePushNotifications(bool value) {
    debugPrint('[SETTINGS PROVIDER] 🔔 Push notifications set to: $value');
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleEmailPromotions(bool value) {
    debugPrint('[SETTINGS PROVIDER] 📧 Email promotions set to: $value');
    _emailPromotions = value;
    notifyListeners();
  }

  void setCurrency(String currency) {
    debugPrint('[SETTINGS PROVIDER] 💱 Currency changed to: $currency');
    _selectedCurrency = currency;
    notifyListeners();
  }
}
