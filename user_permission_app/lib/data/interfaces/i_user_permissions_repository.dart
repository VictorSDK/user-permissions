import 'package:user_permission_app/domain/models/user_permissions.dart';

abstract class IUserPermissionRepository {
  Future upsert(UserPermissions user);

  Future<UserPermissions?> get(String id);
}