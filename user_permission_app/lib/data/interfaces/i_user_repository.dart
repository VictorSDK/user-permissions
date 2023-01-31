import 'package:http/http.dart' as http;
import 'package:user_permission_app/data/models/user.dart';

abstract class IUserRepository {
  Future<List<User>> getAll(http.Client client);
}