import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test_task/model/user.dart';

import '../repositories/pagination_data.dart';
import '../repositories/user_local_storage.dart';
import '../repositories/user_remote_storage.dart';

class UsersFacade {
  static Future<PaginationData> getUsers(int page) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final data = await UserLocalStorage.loadUsersFromStorage(page);
      return data;
    }
    final fetchedData = await UserRemoteStorage.getUsers(page);
    final usersList = fetchedData.users;
    final int totalPages = fetchedData.totalPages;

    await UserLocalStorage.saveUsersToStorage(page, usersList, totalPages);
    return PaginationData(users: usersList, totalPages: totalPages);
  }

  static Future<UserModel> getUserDetails(int userId) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final user = UserLocalStorage.loadUserFromStorage(userId);
      return user;
    }
    final fetchedUser = await UserRemoteStorage.getUserDetails(userId);
    await UserLocalStorage.saveUserToStorage(userId, fetchedUser);
    return fetchedUser;
  }
}
