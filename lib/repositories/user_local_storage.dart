import 'dart:convert';
import 'package:flutter_test_task/repositories/pagination_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user.dart';

const key = 'user_data';

class UserLocalStorage {
  static Future<PaginationData> loadUsersFromStorage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('$key/$page');

    if (cachedData != null) {
      try {
        final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
        final List<UserModel> users = (jsonData['users'] as List)
            .map((user) => UserModel.fromJson(user))
            .toList();
        final int totalPages = jsonData['totalPages'];
        return PaginationData(users: users, totalPages: totalPages);
      } on Exception catch (e) {
        print('Failed to parse users');
        print(e);
      }
    }
    return PaginationData(users: [], totalPages: 0);
  }

  static Future<void> saveUsersToStorage(
    int page,
    List<UserModel> users,
    int totalPages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = {
      'users': users.map((user) => user.toJson()).toList(),
      'totalPages': totalPages,
    };
    prefs.setString('$key/$page', json.encode(jsonData));
  }

  static Future<UserModel> loadUserFromStorage(int userId) async {
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString('user/$userId');

    if (cachedData != null) {
      try {
        final jsonData = jsonDecode(cachedData);
        return UserModel.fromJson(jsonData);
      } on Exception catch (e) {
        print('Failed to parse user');
        print(e);
      }
    }
    return UserModel(
      id: 0,
      email: 'N/A',
      firstName: 'N/A',
      lastName: 'N/A',
      avatar: 'N/A',
    );
  }

  static Future<void> saveUserToStorage(
    int userId,
    UserModel user,
  ) async {
    print('saveUserToStorage');
    final prefs = await SharedPreferences.getInstance();
    final jsonData = user.toJson();
    prefs.setString('user/$userId', json.encode(jsonData));
  }
}
