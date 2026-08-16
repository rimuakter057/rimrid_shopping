import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = true; // Default logged in for smooth demo experience
  bool _isLoading = false;
  bool _hasSeenOnboarding = true;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  AuthProvider() {
    debugPrint('[AUTH PROVIDER] 🔐 Initializing AuthProvider with Default User Session...');
    _currentUser = const UserModel(
      id: 'usr_100',
      name: 'Alex Rimrid',
      email: 'alex.rimrid@example.com',
      phone: '+1 (555) 234-5678',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      address: '742 Evergreen Terrace, Springfield, OR 97477',
    );
  }

  void completeOnboarding() {
    debugPrint('[AUTH PROVIDER] 🚀 Onboarding completed!');
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    debugPrint('[AUTH PROVIDER] 🔑 Login attempt for email: $email');
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Mock network delay

    _currentUser = UserModel(
      id: 'usr_100',
      name: email.split('@').first.toUpperCase(),
      email: email,
      phone: '+1 (555) 234-5678',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
      address: '742 Evergreen Terrace, Springfield, OR 97477',
    );
    _isAuthenticated = true;
    _isLoading = false;
    debugPrint('[AUTH PROVIDER] ✅ User successfully authenticated: ${_currentUser?.name}');
    notifyListeners();
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    debugPrint('[AUTH PROVIDER] 📝 Creating new account for: $name ($email)');
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: '+1 (555) 000-1122',
      address: '123 New Ave, New York, NY 10001',
    );
    _isAuthenticated = true;
    _isLoading = false;
    debugPrint('[AUTH PROVIDER] 🎉 Account created successfully for user ID: ${_currentUser?.id}');
    notifyListeners();
    return true;
  }

  void logout() {
    debugPrint('[AUTH PROVIDER] 🚪 Logging out current user...');
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
