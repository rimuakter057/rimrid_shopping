import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _selectedAddress = '742 Evergreen Terrace, Springfield, OR 97477';
  String _selectedPaymentMethod = 'Credit Card (•••• 4242)';

  String get selectedAddress => _selectedAddress;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  void updateAddress(String newAddress) {
    debugPrint('[PROFILE PROVIDER] 📍 Updated shipping address to: "$newAddress"');
    _selectedAddress = newAddress;
    notifyListeners();
  }

  void updatePaymentMethod(String newMethod) {
    debugPrint('[PROFILE PROVIDER] 💳 Updated payment method to: "$newMethod"');
    _selectedPaymentMethod = newMethod;
    notifyListeners();
  }
}
