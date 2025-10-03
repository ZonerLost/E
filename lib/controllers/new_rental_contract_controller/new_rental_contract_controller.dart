import 'dart:developer';
import 'dart:typed_data';

import 'package:edwardb/config/utils/utils.dart';
import 'package:edwardb/screens/view/new_rental_contract_screens/done_screen.dart';
import 'package:edwardb/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class NewRentalContractController extends GetxController {
  ///
  /// ===== NEW RENTAL CONTRACT ======
  ///
  final isScreenBusy = false.obs;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final contractName = TextEditingController();
  final initialController = TextEditingController();
  final phoneNumber = TextEditingController();
  final cvcNumber = TextEditingController();
  final cardExpiry = TextEditingController();
  final cardNumber = TextEditingController();
  final licenseNumber = TextEditingController();
  final date = TextEditingController();

  late SignatureController signatureController;
  Uint8List? signatureBytes;

  @override
  void onInit() {
    super.onInit();
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  RxnString DRIVER_PHOTO = RxnString();
  RxnString LICENSE_PHOTO = RxnString();

  Future<void> pickDriverPhoto() async {
    try {
      final result = await Utils.pickImageFromCamera();
      if (result == null) throw Exception('No image selected');
      DRIVER_PHOTO.value = result.path;
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> pickLicensePhoto() async {
    try {
      final result = await Utils.pickImageFromCamera();
      if (result == null) throw Exception('No image selected');
      LICENSE_PHOTO.value = result.path;
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  bool validateDriverAndLicensePhoto() {
    if (DRIVER_PHOTO.value == null) {
      Utils.showErrorSnackbar('Error', 'Please take a driver photo.');
      return false;
    }
    if (LICENSE_PHOTO.value == null) {
      Utils.showErrorSnackbar('Error', 'Please take a license photo.');
      return false;
    }
    return true;
  }

  Future<bool> validateSignature() async {
    if (signatureController.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please provide your signature.');
      return false;
    } else {
      signatureBytes = await signatureController.toPngBytes();
      return true;
    }
  }

  Future<void> handleSubmit() async {
    isScreenBusy.value = true;
    try {
      // Create contract using Firebase service
      final contractId = await FirebaseService.instance.createRentalContract(
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        cardNumber: cardNumber.text.trim(),
        date: date.text.trim(),
        driverPhotoPath: DRIVER_PHOTO.value!,
        licensePhotoPath: LICENSE_PHOTO.value!,
        signatureBytes: signatureBytes!,
        initalController: initialController.text.trim(),
        cardCvC: cvcNumber.text.trim(), 
        contractNameController: contractName.text.trim(), 
        cardExpiry: cardExpiry.text.trim(), 
        liscenseNumber: licenseNumber.text.trim()
      );

      if (contractId != null) {
        Utils.showErrorSnackbar('Success', 'Contract created successfully!');
        // _clearForm();
        isScreenBusy.value = false;
        Get.offAll(
          () => DoneScreen(
            contractId: contractId,
            name: '${firstName.text.trim()} ${lastName.text.trim()}',
            imageUrl: DRIVER_PHOTO.value,
          ),
        );
        
      }
    } catch (e) {
      log('Error in handleSubmit: $e');
      Utils.showErrorSnackbar(
        'Error',
        'Failed to create contract. Please try again.',
      );
    } finally {
      isScreenBusy.value = false;
    }
  }

  void clearForm() {
    email.clear();
    firstName.clear();
    lastName.clear();
    phoneNumber.clear();
    cardNumber.clear();
    date.clear();
    DRIVER_PHOTO.value = null;
    LICENSE_PHOTO.value = null;
    signatureController.clear();
    signatureBytes = null;
    licenseNumber.clear();
    cardExpiry.clear();
    cardNumber.clear();
    contractName.clear();
    licenseNumber.clear();
  }
}
