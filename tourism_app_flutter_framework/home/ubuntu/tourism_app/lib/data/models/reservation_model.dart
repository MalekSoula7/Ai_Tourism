import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String id;
  final String userId;
  final String placeId;
  final String placeName;
  final DateTime selectedDateTime;
  final int visitorCount;
  final String status;
  final double price;
  final String paymentStatus;
  final String? qrCodeData;
  final DateTime? createdAt;
  final DateTime? cancelledAt;

  const ReservationModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.selectedDateTime,
    required this.visitorCount,
    required this.status,
    required this.price,
    required this.paymentStatus,
    this.qrCodeData,
    this.createdAt,
    this.cancelledAt,
  });

  factory ReservationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReservationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      placeId: data['placeId'] ?? '',
      placeName: data['placeName'] ?? '',
      selectedDateTime:
          (data['selectedDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      visitorCount: data['visitorCount'] ?? 1,
      status: data['status'] ?? 'pending_payment',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: data['paymentStatus'] ?? 'pending',
      qrCodeData: data['qrCodeData'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'placeId': placeId,
        'placeName': placeName,
        'selectedDateTime': Timestamp.fromDate(selectedDateTime),
        'visitorCount': visitorCount,
        'status': status,
        'price': price,
        'paymentStatus': paymentStatus,
        if (qrCodeData != null) 'qrCodeData': qrCodeData,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
        if (cancelledAt != null) 'cancelledAt': Timestamp.fromDate(cancelledAt!),
      };
}

abstract class ReservationStatus {
  static const pendingPayment = 'pending_payment';
  static const confirmed = 'confirmed';
  static const cancelled = 'cancelled';
  static const expired = 'expired';
  static const used = 'used';
}
