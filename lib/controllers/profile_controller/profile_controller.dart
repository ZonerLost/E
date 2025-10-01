import 'dart:developer';
import 'package:edwardb/model/profile_model.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool controllerIsBusy = false.obs;

  ///
  /// ===== PROFILE ======
  ///

  Rx<ProfileModel> profile = ProfileModel(
    id: '',
    username: '',
    email: '',
    avatarUrl: '',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    if (controllerIsBusy.value) return;

    try {
      controllerIsBusy.value = true;

      // Get profile from FirebaseService
      final profileData = await FirebaseService.instance.getProfile();

      profile.value = profileData;

      log('Profile loaded successfully: ${profile.value.username}');
    } catch (e) {
      log('Error loading profile: $e');

      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controllerIsBusy.value = false;
    }
  }

  // Method to refresh profile data
  Future<void> refreshProfile() async {
    await getProfile();
  }
}
