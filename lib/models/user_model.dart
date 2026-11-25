import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/utils/name_utils.dart';

/// Data of a user (doctor or patient).
///
/// [id] looks like "DOC-6" or "PAT-6" (role prefix + server id), so screens
/// can show and search it directly. Use [apiId] when calling the server.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.specialty = '',
    this.age = '',
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String specialty;
  final String age;

  /// Builds an app ID from the numeric server ID.
  static String makeId(UserRole role, Object? apiId) =>
      '${role == UserRole.doctor ? 'DOC' : 'PAT'}-$apiId';

  /// Numeric ID used by the server.
  int get apiId => int.tryParse(id.split('-').last) ?? 0;

  String get initials => NameUtils.initials(name);

  /// Reads a user from JSON. Also accepts {"user": {...}}.
  /// Throws [FormatException] when the role is missing or unsupported.
  factory UserModel.fromJson(Map<String, dynamic> json, {UserRole? fallbackRole}) {
    final Map<String, dynamic> m = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : json;

    final String roleName = (m['role'] ?? '').toString().toLowerCase();
    final UserRole? role = switch (roleName) {
      'doctor' => UserRole.doctor,
      'patient' => UserRole.patient,
      _ => fallbackRole,
    };
    if (role == null) throw const FormatException('Unsupported role');

    return UserModel(
      id: makeId(role, m['id']),
      name: (m['name'] ?? '').toString(),
      email: (m['email'] ?? '').toString().toLowerCase(),
      role: role,
      phone: (m['phone'] ?? '').toString(),
      specialty: (m['specialty'] ?? '').toString(),
      age: (m['age'] ?? '').toString(),
    );
  }

  UserModel copyWith({String? name, String? phone, String? specialty, String? age}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      age: age ?? this.age,
    );
  }
}