import 'package:user_permission_app/data/models/models.dart';

class UserPermissions {
  UserPermissions({required this.userId, required this.permissions, required this.roles});

  UserPermissions.fromDataModel(User user)
      : this(userId: user.id, permissions: <String>[], roles: <String>[]);

  late final String userId;
  late final String firstName;
  late final String lastName;
  late final List<String> permissions;
  late final List<String> roles;

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'permissions': permissions,
      'roles': roles,
    };
  }

  factory UserPermissions.fromMap(Map<String, dynamic> map) {
    return UserPermissions(
      userId: map['id'],
      permissions: (map['permissions'] as List).map((e) => e as String).toList(),
      roles: (map['roles'] as List).map((e) => e as String).toList(),
    );
  }
}
