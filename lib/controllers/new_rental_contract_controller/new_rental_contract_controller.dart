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
  late SignatureController signatureControllerInital;
  late SignatureController signatureControllerName;
  late SignatureController signatureControllerCard;
  Uint8List? signatureBytes;
  Uint8List? signatureBytesCard;
  Uint8List? signatureBytesInitial;

  @override
  void onInit() {
    super.onInit();
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    signatureControllerInital = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    signatureControllerName = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    signatureControllerCard = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  RxnString DRIVER_PHOTO = RxnString();
  RxnString LICENSE_PHOTO = RxnString();
  RxnString CUSTOMER_LICENSE_PHOTO = RxnString();

  final Map<String, RxBool> agreementChecks = {
    'I agree to the Terms & Conditions': false.obs,
    'I understand the damage policy': false.obs,
    'I agree to the late return penalty': false.obs,
    'I confirm the fuel refill clause': false.obs,
  };

  List<MapEntry<String, RxBool>> get agreementEntries =>
      agreementChecks.entries.toList();

  bool get allAgreementsAccepted =>
      agreementChecks.values.every((element) => element.value);

  Map<String, bool> get agreementStatuses => {
        for (final entry in agreementChecks.entries)
          entry.key: entry.value.value,
      };

  Future<void> pickDriverPhoto() async {
    try {
      final result = await Utils.pickImageFromCamera();
      if (result == null) throw Exception('No image selected');
      DRIVER_PHOTO.value = result.path;
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  clearSignatureOne(){
    signatureControllerName.clear();
  }

  clearSignatureInitial(){
    signatureControllerInital.clear();
  }
  
  clearSignatureCard(){
    signatureControllerCard.clear();
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

  Future<void> pickCustomerLicensePhoto() async {
    try {
      final result = await Utils.pickImageFromCamera();
      if (result == null) throw Exception('No image selected');
      CUSTOMER_LICENSE_PHOTO.value = result.path;
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  bool validateDriverAndLicensePhoto() {
    if (DRIVER_PHOTO.value == null) {
      Utils.showErrorSnackbar('Error', 'Please take a driver photo.');
      return false;
    }

    // if (LICENSE_PHOTO.value == null) {
    //   Utils.showErrorSnackbar('Error', 'Please take a license photo.');
    //   return false;
    // }
    return true;
  }


  



  bool validateDriverLicensePhoto() {
    if (CUSTOMER_LICENSE_PHOTO.value == null) {
      Utils.showErrorSnackbar('Error', 'Please take a license photo.');
      return false;
    }
    return true;
  }

  Future<bool> validateSignature() async {
    if (signatureController.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please provide your signature.');
      return false;
    }
    if (signatureControllerCard.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please provide your card signature.');
      return false;
    }
    if (signatureControllerInital.isEmpty) {
      Utils.showErrorSnackbar('Error', 'Please provide your initials.');
      return false;
    }

    final mainSignature = await signatureController.toPngBytes();
    final cardSignature = await signatureControllerCard.toPngBytes();
    final initialSignature = await signatureControllerInital.toPngBytes();

    if (mainSignature == null ||
        cardSignature == null ||
        initialSignature == null) {
      Utils.showErrorSnackbar(
        'Error',
        'Unable to export signatures. Please try again.',
      );
      return false;
    }

    signatureBytes = mainSignature;
    signatureBytesCard = cardSignature;
    signatureBytesInitial = initialSignature;
    return true;
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
        licensePhotoPath: CUSTOMER_LICENSE_PHOTO.value!,
        driverPhotoPath: DRIVER_PHOTO.value!,
        // licensePhotoPath: LICENSE_PHOTO.value!,
        signatureBytes: signatureBytes!,
        // initalController: initialController.text.trim(),
        cardCvC: cvcNumber.text.trim(), 
        signatureBytesCard: signatureBytesCard!,
        contractNameController: contractName.text.trim(), 
        cardExpiry: cardExpiry.text.trim(), 
        liscenseNumber: licenseNumber.text.trim(),
        signatureBytesInitial: signatureBytesInitial!
      );

     

      if (contractId.isNotEmpty) {
        Utils.showErrorSnackbar('Success', 'Contract created successfully!');
        final fullName =
            '${firstName.text.trim()} ${lastName.text.trim()}'.trim();
        final contractData = {
          'contractId': contractId,
          'contractName': contractName.text.trim(),
          'date': date.text.trim(),
          'firstName': firstName.text.trim(),
          'lastName': lastName.text.trim(),
          'email': email.text.trim(),
          'phoneNumber': phoneNumber.text.trim(),
          'licenseNumber': licenseNumber.text.trim(),
          'cardNumber': cardNumber.text.trim(),
          'cardExpiryDate': cardExpiry.text.trim(),
          'cvc': cvcNumber.text.trim(),
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'agreements': agreementStatuses,
        };
        final images = <String, String>{};
        if (DRIVER_PHOTO.value != null) {
          images['driverPhoto'] = DRIVER_PHOTO.value!;
        }
        if (CUSTOMER_LICENSE_PHOTO.value != null) {
          images['customerLicensePhoto'] = CUSTOMER_LICENSE_PHOTO.value!;
        }
        final signatures = <String, Uint8List>{};
        if (signatureBytes != null) {
          signatures['signature'] = signatureBytes!;
        }
        if (signatureBytesCard != null) {
          signatures['signatureCard'] = signatureBytesCard!;
        }
        if (signatureBytesInitial != null) {
          signatures['signatureInitial'] = signatureBytesInitial!;
        }
        // _clearForm();
        isScreenBusy.value = false;
        Get.offAll(
          () => DoneScreen(
            contractId: contractId,
            name: fullName,
            imageUrl: DRIVER_PHOTO.value,
            contractData: contractData,
            localImagePaths: images,
            signatureBytes: signatures,
            agreementStatuses: agreementStatuses,
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
    signatureBytesCard = null;
    signatureBytesInitial = null;
    licenseNumber.clear();
    cardExpiry.clear();
    cardNumber.clear();
    contractName.clear();
    licenseNumber.clear();
  }





}
