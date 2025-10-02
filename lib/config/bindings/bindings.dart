import 'package:edwardb/controllers/auth_controller/auth_controller.dart';
import 'package:get/get.dart';

final bindings = BindingsBuilder(() {
  Get.lazyPut(() => AuthController());
});