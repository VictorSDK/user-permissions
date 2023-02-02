import 'package:user_permission_app/data/interfaces/i_user_permissions_repository.dart';
import 'package:localstore/localstore.dart';
import 'package:user_permission_app/data/models/user_permissions.dart';

class UserPermissionRepository implements IUserPermissionRepository {
  Future<void> upsert(UserPermissions user) async {
    final db = Localstore.instance;
    await db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserPermissions?> get(String id) async {
    final db = Localstore.instance;
    final map = await db.collection('users').doc(id).get();
    return map != null ? UserPermissions.fromMap(map) : null;
  }
}
