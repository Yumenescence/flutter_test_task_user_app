import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/model/user.dart';
import 'package:flutter_test_task/service/users_controller.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: FutureBuilder<UserModel>(
        future: userController.getUserDetails(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user details'));
          } else {
            final user = snapshot.data;
            if (user != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                        imageUrl: user.avatar,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator()),
                    const SizedBox(height: 20),
                    Text('Name: ${user.name}'),
                    Text('Email: ${user.email}'),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('User not found'));
            }
          }
        },
      ),
    );
  }
}
