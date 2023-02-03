import 'package:user_permission_app/data/models/user_permissions.dart';

abstract class IUserPermissionRepository {
  Future upsert(UserPermissions user);

  Future<UserPermissions?> get(String id);
}
