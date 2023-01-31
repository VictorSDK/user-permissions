import 'dart:convert';
import 'package:user_permission_app/data/interfaces/i_role_repository.dart';
import 'package:user_permission_app/data/models/role.dart';
import 'package:http/http.dart' as http;

class RoleRepository implements IRoleRepository {  

  List<Role> parseRoles(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Role>((json) => Role.fromJson(json)).toList();
  }

  Future<List<Role>> getAll(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://61fc4baf3f1e34001792c875.mockapi.io/api/v1/roles'));

    if (response.statusCode == 200) {
      var roles = parseRoles(response.body);
      return roles;
    } else {
      throw Exception('Failed to load roles');
    }
  }
}