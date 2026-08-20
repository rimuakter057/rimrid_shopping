import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _hasSeenOnboarding = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    debugPrint('[AUTH PROVIDER] 🔐 Restoring persisted session (if any)...');
    _hasSeenOnboarding = LocalStorageService.prefsBox.get('hasSeenOnboarding', defaultValue: false) as bool;

    final storedUser = LocalStorageService.authBox.get('user');
    if (storedUser != null) {
      _currentUser = UserModel.fromJson(storedUser as Map);
      _isAuthenticated = true;
      debugPrint('[AUTH PROVIDER] ✅ Restored session for: ${_currentUser?.name}');
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  void completeOnboarding() {
    debugPrint('[AUTH PROVIDER] 🚀 Onboarding completed!');
    _hasSeenOnboarding = true;
    LocalStorageService.prefsBox.put('hasSeenOnboarding', true);
    notifyListeners();
  }

  /// Locally-registered accounts (created via [signup]) are checked first so a
  /// user can genuinely log back in; DummyJSON's real `/auth/login` is only a
  /// fallback for usernames it doesn't recognize (i.e. the fixed demo accounts).
  Future<bool> login(String username, String password) async {
    debugPrint('[AUTH PROVIDER] 🔑 Login attempt for username: $username');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final key = username.trim().toLowerCase();
    final localRecord = LocalStorageService.usersBox.get(key);

    if (localRecord != null) {
      final record = localRecord as Map;
      if (record['passwordHash'] == _hashPassword(password)) {
        final user = UserModel(
          id: record['id'].toString(),
          username: key,
          name: record['name'] ?? '',
          email: record['email'] ?? '',
          phone: record['phone'] as String?,
          avatarUrl: record['avatarUrl'] as String?,
          address: record['address'] as String?,
        );
        _currentUser = user;
        _isAuthenticated = true;
        _isLoading = false;
        await LocalStorageService.authBox.put('user', user.toJson());
        debugPrint('[AUTH PROVIDER] ✅ Local account authenticated: ${user.name}');
        notifyListeners();
        return true;
      }

      _errorMessage = 'Incorrect password.';
      _isLoading = false;
      debugPrint('[AUTH PROVIDER] ❌ Local login failed: wrong password for "$key"');
      notifyListeners();
      return false;
    }

    try {
      final user = await _repository.login(username, password);
      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      await LocalStorageService.authBox.put('user', user.toJson());
      debugPrint('[AUTH PROVIDER] ✅ User successfully authenticated: ${_currentUser?.name}');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      debugPrint('[AUTH PROVIDER] ❌ Login failed: $_errorMessage');
      notifyListeners();
      return false;
    }
  }

  /// Creates a locally-persisted account (so the same credentials can log back
  /// in later) and, best-effort, mirrors the signup to DummyJSON's `/users/add`
  /// demo endpoint. Does not authenticate the user — signup is followed by a
  /// redirect to the login screen.
  Future<bool> signup(String name, String email, String password) async {
    debugPrint('[AUTH PROVIDER] 📝 Creating new account for: $name ($email)');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final username = email.trim().split('@').first.toLowerCase();

    if (username.isEmpty || LocalStorageService.usersBox.containsKey(username)) {
      _errorMessage = 'An account with this email already exists — please sign in.';
      _isLoading = false;
      debugPrint('[AUTH PROVIDER] ❌ Signup failed: username "$username" already registered');
      notifyListeners();
      return false;
    }

    await LocalStorageService.usersBox.put(username, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name.trim(),
      'email': email.trim(),
      'phone': null,
      'address': '742 Evergreen Terrace, Springfield, OR 97477',
      'avatarUrl': null,
      'passwordHash': _hashPassword(password),
    });

    try {
      await _repository.signup(name, email, password);
    } catch (e) {
      debugPrint('[AUTH PROVIDER] ⚠️ DummyJSON signup side-call failed (local account still created): $e');
    }

    _isLoading = false;
    debugPrint('[AUTH PROVIDER] 🎉 Local account created for username: $username');
    notifyListeners();
    return true;
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      name: name,
      phone: phone,
      address: address,
      avatarUrl: avatarUrl,
    );
    await LocalStorageService.authBox.put('user', _currentUser!.toJson());

    final key = _currentUser!.username.toLowerCase();
    final existing = LocalStorageService.usersBox.get(key);
    if (existing != null) {
      final record = Map<dynamic, dynamic>.from(existing as Map);
      record['name'] = _currentUser!.name;
      record['phone'] = _currentUser!.phone;
      record['address'] = _currentUser!.address;
      record['avatarUrl'] = _currentUser!.avatarUrl;
      await LocalStorageService.usersBox.put(key, record);
    }

    debugPrint('[AUTH PROVIDER] ✏️ Profile updated for: ${_currentUser!.name}');
    notifyListeners();
  }

  void loginAsGuest() {
    debugPrint('[AUTH PROVIDER] 👤 Continuing as guest...');
    const guest = UserModel(
      id: 'guest',
      username: 'guest',
      name: 'Guest Shopper',
      email: 'guest@rimrid.com',
      address: '742 Evergreen Terrace, Springfield, OR 97477',
    );
    _currentUser = guest;
    _isAuthenticated = true;
    LocalStorageService.authBox.put('user', guest.toJson());
    notifyListeners();
  }

  void logout() {
    debugPrint('[AUTH PROVIDER] 🚪 Logging out current user...');
    _isAuthenticated = false;
    _currentUser = null;
    LocalStorageService.authBox.delete('user');
    notifyListeners();
  }
}
