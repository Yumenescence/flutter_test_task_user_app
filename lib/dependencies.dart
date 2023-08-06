import 'package:flutter_test_task/repositories/user_local_storage.dart';
import 'package:get/get.dart';

import 'repositories/user_remote_storage.dart';

final UserLocalStorage userLocalStorage = Get.put(UserLocalStorage());
final UserRemoteStorage userRemoteStorage = Get.put(UserRemoteStorage());
