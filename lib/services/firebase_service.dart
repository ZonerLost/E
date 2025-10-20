import 'dart:io';
import 'dart:math';
import 'dart:developer' as log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edwardb/model/contract_model.dart';
import 'package:edwardb/model/profile_model.dart';
import 'package:edwardb/services/google_drive_services.dart';
import 'package:edwardb/services/share_pref_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../config/routes/routes_names.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

   Future<void> signIn(String email, String password, bool remember) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("No user found");
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception("User profile not found in Firestore");
      }
     
      // Save user ID locally if remember me is checked
      if (remember) {
        await SharePrefService.instance.addUserId(user.uid);
      } 
      
      Get.offAllNamed(RouteName.dashboardScreen);
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      } else {
        throw Exception('Auth error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }


  Future<void> userLogout() async {
    try {
      await _auth.signOut();
      await SharePrefService.instance.clearUserId();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }


  Future<String> getCurrentUser() async{
    final uuid =  _auth.currentUser!.uid;
      return uuid;

  }


   Future<ProfileModel> getProfile() async {
    try {

      
      final userId = await SharePrefService.instance.getUserId();

      if (userId == null || userId.isEmpty) {
        final uuid = await getCurrentUser();
        final userDoc = await _firestore.collection('users').doc(uuid).get();
        if(!userDoc.exists){
        throw Exception("User not found in Firestore. without remember me enable");
        }

      return ProfileModel.fromJson(userDoc.data() as Map<String, dynamic>, uuid);
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception("User not found in Firestore.");
      }

      return ProfileModel.fromJson(userDoc.data() as Map<String, dynamic>, userId);
    } catch (e) {
      throw Exception("Failed to get profile: $e");
    }
  }


  Future<String> createRentalContract({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String cardNumber,
    required String liscenseNumber,
    required String cardCvC,
    // required String initalController,
    required String contractNameController,
    required String cardExpiry,
    required String date,
    required String driverPhotoPath,
    // required String licensePhotoPath,
    required String licensePhotoCustomer,
    required Uint8List signatureBytes,
    required Uint8List signatureBytesCard,
    required Uint8List signatureBytesInitals,
  }) async {
    try {
      // Generate contract ID first
      final contractRef = _firestore.collection('contracts').doc();
      final contractId = contractRef.id;

      // Upload driver photo to Firebase Storage
      final driverPhotoRef = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'driver-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );

      // Read driver photo file
      final driverPhotoBytes = await File(driverPhotoPath).readAsBytes();
      await driverPhotoRef.putData(driverPhotoBytes);
      final driverPhotoUrl = await driverPhotoRef.getDownloadURL();
      // Upload driver photo to Firebase Storage
      final customerDriverPhotoRef = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'license-driver-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );

      // Read driver photo file
      final customerDriverPhotoBytes = await File(driverPhotoPath).readAsBytes();
      await customerDriverPhotoRef.putData(customerDriverPhotoBytes);
      final customerDriverPhotoUrl = await driverPhotoRef.getDownloadURL();

      // Upload license photo to Firebase Storage
      // final licensePhotoRef = _storage
      //     .ref()
      //     .child('contracts')
      //     .child(contractId)
      //     .child(
      //       'license-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
      //     );

      // Read license photo file
      // final licensePhotoBytes = await File(licensePhotoPath).readAsBytes();
      // await licensePhotoRef.putData(licensePhotoBytes);
      // final licensePhotoUrl = await licensePhotoRef.getDownloadURL();

      // Upload signature to Firebase Storage
      final signatureRef = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'signature-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );

      // Signature of Card
      final signatureRefCard = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'card-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );
      // Signature Initals
      final signatureRefInitial = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'inital-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );

      await signatureRef.putData(signatureBytes);
      final signatureUrl = await signatureRef.getDownloadURL();

      await signatureRefCard.putData(signatureBytesCard);
      final signatureUrlCard = await signatureRefCard.getDownloadURL();

      await signatureRefInitial.putData(signatureBytesCard);
      final signatureInitial = await signatureRefCard.getDownloadURL();

      // Create rental contract document in Firestore
      final contractData = {
        'contractId': contractId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'cardNumber': cardNumber,
        'date': date,
        'customerDriverLiscensePhotoUrl': customerDriverPhotoUrl,
        'licenseNumber' : liscenseNumber,
        'driverPhotoUrl': driverPhotoUrl,
        // 'licensePhotoUrl': licensePhotoUrl,
        'signatureUrl': signatureUrl,
        'signatureCard': signatureUrlCard,
        'cvc': cardCvC,
        'cardExpiryDate': cardExpiry,
        'contractName': contractNameController,
        // 'inital': initalController,
        'initalSignature': signatureInitial,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      log.log('Contract Data: $contractData');

      await contractRef.set(contractData);
      await GoogleDriveService.uploadContractBundleToSharedDrive(
  sharedDriveId: "13Epy1TxTK3gRvKXLXc6IbNspYu05mRJ2",
  username: "$firstName $lastName",
  contractId: contractId,
  contractData: contractData,
  parentFolderName: 'Contracts', // optional parent in the drive
  imageFilePaths: {
    if (driverPhotoPath.isNotEmpty) 'driverPhoto': driverPhotoPath,
    if (licensePhotoCustomer.isNotEmpty) 'customerLicensePhoto': licensePhotoCustomer,
    // if you also captured a separate license photo path:
    // 'licensePhoto': licensePhotoPath,
  },
  imageBytes: {
    'signature': signatureBytes,
    'signatureCard': signatureBytesCard,
    'signatureInitial': signatureBytesInitals,
  },
  anyoneCanView: false, // set true if you want link-shareable files
);
      return contractId;
    } catch (e) {
      throw Exception('Failed to create rental contract: $e');
    }
  }

  // Helper function to generate random string for unique file names
  String _generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<bool> submitInspection({
    required String  name,
    required String contractId,
    required String videoFilePath,
    required Uint8List signatureBytes,
  }) async {
    try {
      // Upload video to Firebase Storage
      final videoRef = _storage
          .ref()
          .child('inspections')
          .child(contractId)
          .child(
            'video-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.mp4',
          );

      // Read video file
      final videoBytes = await File(videoFilePath).readAsBytes();
      await videoRef.putData(videoBytes);
      final videoUrl = await videoRef.getDownloadURL();

      // Upload signature to Firebase Storage
      final signatureRef = _storage
          .ref()
          .child('inspections')
          .child(contractId)
          .child(
            'signature-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );
      await signatureRef.putData(signatureBytes);
      final signatureUrl = await signatureRef.getDownloadURL();

      // Update contract document in Firestore with inspection data
      final inspectionData = {
        'inspection': {
          'videoUrl': videoUrl,
          'contractorId': contractId,
          'signatureUrl': signatureUrl,
          'submittedAt': FieldValue.serverTimestamp(),
        },
        'status': 'inspection_submitted',
        'updatedAt': FieldValue.serverTimestamp(),
      };

       await GoogleDriveService.uploadContractBundleToSharedDrive(
      sharedDriveId: "1eG_P8KSek5-_dv-gMqkPjae4t2TO9vbS",
      username: name,                 
      contractId: contractId,             
      parentFolderName: 'Contracts',     
      contractData: {
        'type': 'inspection',
        'contractId': contractId,
        'videoUrl': videoUrl,
        'signatureUrl': signatureUrl,
        // For the JSON snapshot we can add a local timestamp too:
        'submittedAtLocal': DateTime.now().toIso8601String(),
      },
      // Upload the original local files too:
      imageFilePaths: {
        'inspectionVideo': videoFilePath, // will detect mime and upload as file
      },
      imageBytes: {
        'inspectionSignature': signatureBytes, // uploads as "<username> - inspectionSignature.png"
      },
      anyoneCanView: false, // set true if you want link-shareable files
    );

      await _firestore.collection('inspection').add(inspectionData);

      return true;
    } catch (e) {
      throw Exception('Failed to submit inspection: $e');
    }
  }



Future<Map<String, dynamic>> getUserContracts() async {
  try {
    // Get logged-in profile
    final profile = await getProfile();

    // Fetch contracts by email (since you're storing email in contracts)
    final querySnapshot = await _firestore
        .collection('contracts')
        .where('email', isEqualTo: profile.email.toLowerCase())
        .get();


    // Convert all docs into ContractModel list
    final allContracts = querySnapshot.docs.map((doc) {
      return ContractModel.fromJson(doc.data(), doc.id);
    }).toList();

    // Total contracts
    final totalContracts = allContracts.length;

    // Contracts this month
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final monthlyContracts = allContracts.where((contract) {
      return contract.createdAt != null &&
          contract.createdAt!.isAfter(startOfMonth);
    }).toList();

    // Active contracts
    final activeContracts = allContracts.where((contract) {
      return contract.status == 'active';
    }).toList();

    return {
      'totalContracts': totalContracts,
      'monthlyContracts': monthlyContracts.length,
      'activeContracts': activeContracts.length,
      'contractsList': allContracts,
    };
  } catch (e) {
    throw Exception('Failed to fetch contracts: $e');
  }
}

  Future<List<ContractModel>> getAllUserContracts() async {
    try {
      // Get logged-in profile
      final profile = await getProfile();

      // Fetch contracts by email
      final querySnapshot = await _firestore
          .collection('contracts')
          .where('email', isEqualTo: profile.email.toLowerCase())
          .get();

      // Convert all docs into ContractModel list
      final allContracts = querySnapshot.docs.map((doc) {
        return ContractModel.fromJson(doc.data(), doc.id);
      }).toList();

      return allContracts;
    } catch (e) {
      throw Exception('Failed to fetch all contracts: $e');
    }
  }


Future<ContractModel?> markContractAsComplete(String contractId) async {
  try {
    final contractRef = _firestore.collection('contracts').doc(contractId);

    // Update only status field
    await contractRef.update({
      'status': 'complete',
      'updatedAt': DateTime.now(),
    });

    // Fetch updated document to return latest data
    final updatedDoc = await contractRef.get();

    if (updatedDoc.exists) {
      return ContractModel.fromJson(updatedDoc.data()!, updatedDoc.id);
    } else {
      return null;
    }
  } catch (e) {
    throw Exception('Failed to update contract status: $e');
  }
}



}
