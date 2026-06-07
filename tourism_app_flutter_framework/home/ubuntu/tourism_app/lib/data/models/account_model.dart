import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String uid;
  final String name;
  final String email;
  final String status;
  final int credits;
  final String behaviorStatus;
  final DateTime? createdAt;
  final String? passportUrl;
  final DateTime? passportUploadedAt;
  final String? passportNumber;
  final String? passportCountry;
  final String? passportNationality;
  final String? passportGivenNames;
  final String? passportSurname;
  final String? passportDateOfBirth;
  final String? passportExpiryDate;
  final String? passportMrz;
  final DateTime? passportVerifiedAt;
  final String? passportRejectedReason;
  final String? verifiedBy;

  const AccountModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.status,
    required this.credits,
    this.behaviorStatus = 'good_standing',
    this.createdAt,
    this.passportUrl,
    this.passportUploadedAt,
    this.passportNumber,
    this.passportCountry,
    this.passportNationality,
    this.passportGivenNames,
    this.passportSurname,
    this.passportDateOfBirth,
    this.passportExpiryDate,
    this.passportMrz,
    this.passportVerifiedAt,
    this.passportRejectedReason,
    this.verifiedBy,
  });

  factory AccountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? 'pending_passport',
      credits: data['credits'] ?? 0,
      behaviorStatus: data['behaviorStatus'] ?? 'good_standing',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      passportUrl: data['passportUrl'],
      passportUploadedAt: (data['passportUploadedAt'] as Timestamp?)?.toDate(),
      passportNumber: data['passportNumber'],
      passportCountry: data['passportCountry'],
      passportNationality: data['passportNationality'],
      passportGivenNames: data['passportGivenNames'],
      passportSurname: data['passportSurname'],
      passportDateOfBirth: data['passportDateOfBirth'],
      passportExpiryDate: data['passportExpiryDate'],
      passportMrz: data['passportMrz'],
      passportVerifiedAt: (data['passportVerifiedAt'] as Timestamp?)?.toDate(),
      passportRejectedReason: data['passportRejectedReason'],
      verifiedBy: data['verifiedBy'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'status': status,
        'credits': credits,
        'behaviorStatus': behaviorStatus,
        if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
        if (passportUrl != null) 'passportUrl': passportUrl,
        if (passportNumber != null) 'passportNumber': passportNumber,
        if (passportCountry != null) 'passportCountry': passportCountry,
        if (passportNationality != null) 'passportNationality': passportNationality,
        if (passportGivenNames != null) 'passportGivenNames': passportGivenNames,
        if (passportSurname != null) 'passportSurname': passportSurname,
        if (passportDateOfBirth != null) 'passportDateOfBirth': passportDateOfBirth,
        if (passportExpiryDate != null) 'passportExpiryDate': passportExpiryDate,
        if (passportMrz != null) 'passportMrz': passportMrz,
      };
}

abstract class AccountStatus {
  static const pendingPassport = 'pending_passport';
  static const underVerification = 'under_verification';
  static const verified = 'verified';
  static const rejected = 'rejected';
}

abstract class BehaviorStatus {
  static const goodStanding = 'good_standing';
  static const warning = 'warning';
  static const sanctioned = 'sanctioned';
  static const suspended = 'suspended';
}
