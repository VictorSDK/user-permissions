import 'package:http/http.dart' as http;
import 'package:user_permission_app/data/models/permission.dart';

abstract class IPermissionRepository {
  Future<List<Permission>> getAll(http.Client client);
}