import 'dart:convert';
import 'package:flutter_test_task/model/pagination_data.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

const String baseUrl = 'https://reqres.in/api/users';

class UserRemoteStorage {
  static Future<PaginationData<UserModel>> getUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List usersData = jsonData['data'];

      final users = usersData.map((user) => UserModel.fromJson(user)).toList();
      final int totalPages = jsonData['total_pages'];
      return PaginationData(data: users, totalPages: totalPages);
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<UserModel> getUserDetails(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final Map<String, dynamic> userData = data['data'];
      return UserModel.fromJson(userData);
    } else {
      throw Exception('Failed to load user details');
    }
  }
}
