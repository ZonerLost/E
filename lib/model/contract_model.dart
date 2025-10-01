import 'package:cloud_firestore/cloud_firestore.dart';

class ContractModel {
  final String contractId;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String cardNumber;
  final String date;
  final String driverPhotoUrl;
  final String licensePhotoUrl;
  final String signatureUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContractModel({
    required this.contractId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.cardNumber,
    required this.date,
    required this.driverPhotoUrl,
    required this.licensePhotoUrl,
    required this.signatureUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert Firestore JSON to Model
  factory ContractModel.fromJson(Map<String, dynamic> json, String id) {
    return ContractModel(
      contractId: json['contractId'] ?? id,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      date: json['date'] ?? '',
      driverPhotoUrl: json['driverPhotoUrl'] ?? '',
      licensePhotoUrl: json['licensePhotoUrl'] ?? '',
      signatureUrl: json['signatureUrl'] ?? '',
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert Model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
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
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }
}
