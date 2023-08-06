import 'package:flutter_test_task/model/user.dart';
import 'package:flutter_test_task/service/users_facade.dart';
import 'package:get/get.dart';

import '../model/pagination_data.dart';

class UserController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> users = <UserModel>[].obs;
  RxInt page = 1.obs;
  RxInt totalPages = 0.obs;

  bool get isLastPage => page.value == totalPages.value;
  final UsersFacade usersFacade = UsersFacade();

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      isLoading(true);
      final PaginationData<UserModel> paginationData =
          await usersFacade.getUsers(page.value);
      totalPages.value = paginationData.totalPages;
      users.addAll(paginationData.data);
    } catch (e) {
      Get.snackbar('Failed to get users', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<UserModel> getUserDetails(int userId) async {
    try {
      final response = await usersFacade.getUserDetails(userId);
      if (response != null) {
        return response;
      }
    } catch (e) {
      print('Error getting user details: $e');
    }

    Get.snackbar('Failed to get user', 'Check your internet connection');
    return UserModel(
      id: 0,
      firstName: 'N/A',
      lastName: 'N/A',
      email: 'N/A',
      avatar: '',
    );
  }

  void goToNextPage() {
    page.value++;
    getUsers();
  }
}
