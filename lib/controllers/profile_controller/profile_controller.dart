import 'dart:developer';
import 'package:edwardb/config/routes/routes_names.dart';
import 'package:edwardb/model/contract_model.dart';
import 'package:edwardb/model/profile_model.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool controllerIsBusy = false.obs;

  var totalContracts = 0.obs;
  var monthlyContracts = 0.obs;
  var activeContracts = 0.obs;

  // Observable list for contracts
  var contractsList = <ContractModel>[].obs;

  ///
  /// ===== PROFILE ======
  ///
  Rx<ProfileModel> profile = ProfileModel(
    id: '',
    username: '',
    email: '',
    avatarUrl: '',
  ).obs;


  Future<void> getProfile() async {
    try {
      controllerIsBusy.value = true;

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

  Future<void> fetchContracts() async {
    try {
      controllerIsBusy.value = true;

      final contractsData = await FirebaseService.instance.getUserContracts();

      totalContracts.value = contractsData['totalContracts'];
      monthlyContracts.value = contractsData['monthlyContracts'];
      activeContracts.value = contractsData['activeContracts'];
      // contractsList.assignAll(contractsData['contractsList']);
    } catch (e) {
      log("Error fetching contracts: $e");
    } finally {
      controllerIsBusy.value = false;
    }
  }

  /// ===== NEW METHOD: Fetch all contracts list only =====
  Future<void> fetchAllContracts() async {
    try {
      controllerIsBusy.value = true;

      final allContracts =
      await FirebaseService.instance.getAllUserContracts();

      contractsList.assignAll(allContracts);

      log("Fetched all contracts: ${contractsList.length}");
    } catch (e) {
      log("Error fetching all contracts: $e");
    } finally {
      controllerIsBusy.value = false;
    }
  }

  // Method to refresh profile data
  Future<void> refreshProfile() async {
    await getProfile();
  }

  Future<void> logOut() async {
    await FirebaseService.instance.userLogout();
    Get.offAllNamed(RouteName.loginScreen);
  }
}
