import 'package:user_permission_app/data/models/role.dart';

abstract class IRoleRepository {
  Future<List<Role>> getAll();
}