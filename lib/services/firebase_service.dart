import 'dart:io';
import 'dart:math';
import 'dart:developer' as log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edwardb/model/profile_model.dart';
import 'package:edwardb/services/share_pref_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  Future<void> signIn(String email, String password, bool remember) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No user found for that email.');
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      if (userData['password'] != password) {
        throw Exception('Wrong password provided for that user.');
      }

      // Save user ID locally if remember me is checked
      if (remember) {
        await SharePrefService.instance.addUserId(userDoc.id);
      } else {
        // Clear saved user ID if remember me is not checked
        await SharePrefService.instance.clearUserId();
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      // Get user ID from SharedPreferences
      final userId = await SharePrefService.instance.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('No user ID found. Please login again.');
      }

      // Get user data from Firestore
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found. Please login again.');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      return ProfileModel.fromJson(userData, userId);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<String> createRentalContract({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String cardNumber,
    required String date,
    required String driverPhotoPath,
    required String licensePhotoPath,
    required Uint8List signatureBytes,
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

      // Upload license photo to Firebase Storage
      final licensePhotoRef = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'license-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );

      // Read license photo file
      final licensePhotoBytes = await File(licensePhotoPath).readAsBytes();
      await licensePhotoRef.putData(licensePhotoBytes);
      final licensePhotoUrl = await licensePhotoRef.getDownloadURL();

      // Upload signature to Firebase Storage
      final signatureRef = _storage
          .ref()
          .child('contracts')
          .child(contractId)
          .child(
            'signature-${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString()}.png',
          );
      await signatureRef.putData(signatureBytes);
      final signatureUrl = await signatureRef.getDownloadURL();

      // Create rental contract document in Firestore
      final contractData = {
        'contractId': contractId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'cardNumber': cardNumber,
        'date': date,
        'driverPhotoUrl': driverPhotoUrl,
        'licensePhotoUrl': licensePhotoUrl,
        'signatureUrl': signatureUrl,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      log.log('Contract Data: $contractData');

      await contractRef.set(contractData);
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

      await _firestore.collection('inspection').add(inspectionData);

      return true;
    } catch (e) {
      throw Exception('Failed to submit inspection: $e');
    }
  }
}
