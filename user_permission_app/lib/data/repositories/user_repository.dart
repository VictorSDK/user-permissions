import 'dart:convert';
import 'package:user_permission_app/data/interfaces/i_user_repository.dart';
import 'package:user_permission_app/data/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository implements IUserRepository {  

  List<User> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  @override
  Future<List<User>> getAll() async {
    final response = await http.Client()
        .get(Uri.parse('https://61fc4baf3f1e34001792c875.mockapi.io/api/v1/users'));

    if (response.statusCode == 200) {
      var users = parseUsers(response.body);
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}