import 'dart:convert';
import 'package:flutter_test_task/model/pagination_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user.dart';

const key = 'user_data';
const totalLoadedPagesKey = 'total_loaded_pages';

class UserLocalStorage {
  final Future<SharedPreferences> _sharedPreferences;
  UserLocalStorage(this._sharedPreferences);

  Future<int> get totalLoadedPages async {
    final prefs = await _sharedPreferences;
    return prefs.getInt(totalLoadedPagesKey) ?? 0;
  }

  Future<PaginationData<UserModel>> loadUsersFromStorage(int page) async {
    final prefs = await _sharedPreferences;
    final cachedData = prefs.getString('$key/$page');

    if (cachedData != null) {
      try {
        final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
        final List<UserModel> users = (jsonData['users'] as List)
            .map((user) => UserModel.fromJson(user))
            .toList();

        return PaginationData(data: users, totalPages: await totalLoadedPages);
      } on Exception catch (e) {
        print('Failed to parse users');
        print(e);
      }
    }
    return PaginationData(data: [], totalPages: 0);
  }

  Future<void> saveUsersToStorage(
    int page,
    List<UserModel> users,
    int loadedPages,
  ) async {
    final prefs = await _sharedPreferences;
    final jsonData = {
      'users': users.map((user) => user.toJson()).toList(),
      'loadedPages': loadedPages,
    };
    prefs.setString('$key/$page', json.encode(jsonData));
  }

  Future<void> saveTotalLoadedPages(int totalLoadedPages) async {
    final prefs = await _sharedPreferences;
    prefs.setInt(totalLoadedPagesKey, totalLoadedPages);
  }

  Future<UserModel?> loadUserFromStorage(int userId) async {
    final prefs = await _sharedPreferences;

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
    return null;
  }

  Future<void> saveUserToStorage(
    int userId,
    UserModel user,
  ) async {
    final prefs = await _sharedPreferences;
    final jsonData = user.toJson();
    prefs.setString('user/$userId', json.encode(jsonData));
  }
}
