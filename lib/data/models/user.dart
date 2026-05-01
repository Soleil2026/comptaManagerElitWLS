class User {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final String role;
  final String? fullName;
  final DateTime createdAt;
  final bool isActive;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.fullName,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'role': role,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      role: map['role'] as String,
      fullName: map['full_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      isActive: (map['is_active'] as int) == 1,
    );
  }
}