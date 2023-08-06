import '../model/user.dart';

class PaginationData {
  List<UserModel> users;
  int totalPages;

  PaginationData({
    required this.users,
    required this.totalPages,
  });
}
