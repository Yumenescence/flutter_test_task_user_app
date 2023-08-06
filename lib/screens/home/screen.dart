import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/service/users_controller.dart';
import 'package:get/get.dart';

import '../details/screen.dart';

class UserListScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Obx(() {
        if (userController.isLoading.value && userController.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollEndNotification &&
                  !userController.isLoading.value &&
                  !userController.isLastPage &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                userController.goToNextPage();
                return true;
              }
              return false;
            },
            child: ListView.builder(
              itemCount: userController.users.length + 1,
              itemBuilder: (context, index) {
                if (index < userController.users.length) {
                  final user = userController.users[index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CachedNetworkImage(
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            imageUrl: user.avatar,
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          onTap: () {
                            Get.to(() => UserDetailsScreen(userId: user.id));
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 8,
                            left: 12,
                            right: 12,
                          ),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lacus massa, mollis id enim sed, congue condimentum neque. Donec dignissim vestibulum nulla et vestibulum. Morbi eget ex id mi molestie finibus eget ac erat.'),
                        ),
                      ],
                    ),
                  );
                } else if (!userController.isLastPage) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox();
              },
            ),
          );
        }
      }),
    );
  }
}
