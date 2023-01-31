import 'package:user_permission_app/data/models/role.dart';
import 'package:http/http.dart' as http;

abstract class IRoleRepository {
  Future<List<Role>> getAll(http.Client client);
}