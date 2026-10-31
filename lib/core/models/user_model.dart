// lib/core/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'user' or 'admin'
  final String? phone;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'user',
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      if (phone != null) 'phone': phone,
    };
  }
}
