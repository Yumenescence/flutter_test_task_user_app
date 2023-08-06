import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test_task/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pagination_data.dart';
import '../repositories/user_local_storage.dart';
import '../repositories/user_remote_storage.dart';

class UsersFacade {
  UsersFacade();

  final UserLocalStorage userLocalStorage =
      UserLocalStorage(SharedPreferences.getInstance());

  Future<PaginationData<UserModel>> getUsers(int pageNumber) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return _getUsersOffline(pageNumber);
    } else {
      return _getUsersOnline(pageNumber);
    }
  }

  Future<PaginationData<UserModel>> _getUsersOffline(int pageNumber) async {
    final data = await userLocalStorage.loadUsersFromStorage(pageNumber);
    return data;
  }

  Future<PaginationData<UserModel>> _getUsersOnline(int pageNumber) async {
    final fetchedData = await UserRemoteStorage.getUsers(pageNumber);
    final usersList = fetchedData.data;
    final int totalPages = fetchedData.totalPages;
    final int totalLoadedPages = await userLocalStorage.totalLoadedPages;
    final int loadedPages =
        pageNumber > totalLoadedPages ? pageNumber : totalLoadedPages;

    await userLocalStorage.saveTotalLoadedPages(loadedPages);
    await userLocalStorage.saveUsersToStorage(
        pageNumber, usersList, loadedPages);

    return PaginationData<UserModel>(data: usersList, totalPages: totalPages);
  }

  Future<UserModel?> getUserDetails(int userId) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      final user = userLocalStorage.loadUserFromStorage(userId);
      return user;
    }
    final fetchedUser = await UserRemoteStorage.getUserDetails(userId);
    await userLocalStorage.saveUserToStorage(userId, fetchedUser);
    return fetchedUser;
  }
}
