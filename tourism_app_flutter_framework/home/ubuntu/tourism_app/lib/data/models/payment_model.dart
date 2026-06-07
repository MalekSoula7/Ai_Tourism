import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String provider;
  final String? providerPaymentId;
  final String status;
  final String purpose;
  final String? relatedReservationId;
  final String? relatedTicketId;
  final DateTime createdAt;
  final DateTime? paidAt;

  const PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.provider,
    this.providerPaymentId,
    required this.status,
    required this.purpose,
    this.relatedReservationId,
    this.relatedTicketId,
    required this.createdAt,
    this.paidAt,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] ?? 'USD',
      provider: data['provider'] ?? 'mock',
      providerPaymentId: data['providerPaymentId'],
      status: data['status'] ?? 'pending',
      purpose: data['purpose'] ?? '',
      relatedReservationId: data['relatedReservationId'],
      relatedTicketId: data['relatedTicketId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paidAt: (data['paidAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'amount': amount,
        'currency': currency,
        'provider': provider,
        if (providerPaymentId != null) 'providerPaymentId': providerPaymentId,
        'status': status,
        'purpose': purpose,
        if (relatedReservationId != null)
          'relatedReservationId': relatedReservationId,
        if (relatedTicketId != null) 'relatedTicketId': relatedTicketId,
        'createdAt': Timestamp.fromDate(createdAt),
        if (paidAt != null) 'paidAt': Timestamp.fromDate(paidAt!),
      };
}

abstract class PaymentStatus {
  static const pending = 'pending';
  static const paid = 'paid';
  static const failed = 'failed';
  static const refunded = 'refunded';
  static const cancelled = 'cancelled';
}
