class Client {
  final int? id;
  final String name;
  final String? code;
  final String? ice;
  final String? rc;
  final String? address;
  final String? phone;
  final String? email;
  final String? contactPerson;
  final DateTime createdAt;
  final bool isActive;

  Client({
    this.id,
    required this.name,
    this.code,
    this.ice,
    this.rc,
    this.address,
    this.phone,
    this.email,
    this.contactPerson,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'ice': ice,
      'rc': rc,
      'address': address,
      'phone': phone,
      'email': email,
      'contact_person': contactPerson,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      name: map['name'] as String,
      code: map['code'] as String?,
      ice: map['ice'] as String?,
      rc: map['rc'] as String?,
      address: map['address'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      contactPerson: map['contact_person'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      isActive: (map['is_active'] as int) == 1,
    );
  }
}