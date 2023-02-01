
import 'package:user_permission_app/data/models/models.dart' as data;

class UserPermissions{
  UserPermissions({
    required this.id, 
    required this.firstName, 
    required this.lastName, 
    required this.permissions, 
    required this.roles
  });

  UserPermissions.fromDataModel(data.User user) : this(id: user.id, firstName: user.firstName, lastName: user.lastName, permissions: <String>[], roles: <Role>[]);

  late final String id;
  late final String firstName;
  late final String lastName;
  late final List<String> permissions;
  late final List<Role> roles;


  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'permissions': permissions,
    'roles': roles,
  };
  }

  factory UserPermissions.fromMap(Map<String, dynamic> map) {
    return UserPermissions(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      permissions: map['permissions'],
      roles: map['roles'],
    );
  }
}

class Role {
  Role({
    required this.id, 
    required this.name, 
    required this.permissions
  });

  final String id;
  final String name;
  final List<String> permissions;
}