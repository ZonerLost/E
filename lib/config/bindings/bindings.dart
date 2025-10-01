import 'package:edwardb/controllers/auth_controller/auth_controller.dart';
import 'package:edwardb/controllers/new_rental_contract_controller/new_rental_contract_controller.dart';
import 'package:edwardb/controllers/profile_controller/profile_controller.dart';
import 'package:get/get.dart';

final bindings = BindingsBuilder(() {
  Get.lazyPut(() => AuthController());
});
