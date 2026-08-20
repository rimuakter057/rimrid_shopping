class UserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? address;

  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.address,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'address': address,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: (json['username'] ?? '').toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      address: json['address'] as String?,
    );
  }

  /// Maps a DummyJSON `/auth/login` or `/users/add` response into a [UserModel].
  factory UserModel.fromDummyJson(Map<String, dynamic> json, {String? fallbackAddress}) {
    final firstName = (json['firstName'] ?? '').toString();
    final lastName = (json['lastName'] ?? '').toString();
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    return UserModel(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      username: (json['username'] ?? '').toString(),
      name: fullName.isNotEmpty ? fullName : (json['username'] ?? 'User').toString(),
      email: (json['email'] ?? '').toString(),
      phone: json['phone']?.toString(),
      avatarUrl: json['image']?.toString(),
      address: fallbackAddress ?? '742 Evergreen Terrace, Springfield, OR 97477',
    );
  }
}
