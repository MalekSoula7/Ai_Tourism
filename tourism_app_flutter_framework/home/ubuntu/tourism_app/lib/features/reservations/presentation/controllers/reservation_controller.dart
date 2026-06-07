import 'package:get/get.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/data/models/reservation_model.dart';
import 'package:tourism_app/data/repositories/payment_repository.dart';
import 'package:tourism_app/data/repositories/reservation_repository.dart';

class ReservationController extends GetxController {
  final _reservationRepo = ReservationRepository();
  final _paymentRepo = PaymentRepository();

  final RxList<ReservationModel> userReservations = <ReservationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  final Rx<PlaceModel?> selectedPlace = Rx<PlaceModel?>(null);
  final Rx<DateTime> selectedDateTime = DateTime.now().add(const Duration(days: 1)).obs;
  final RxInt visitorCount = 1.obs;
  final Rx<ReservationModel?> lastCreatedReservation = Rx<ReservationModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserReservations();
  }

  Future<void> loadUserReservations() async {
    isLoading(true);
    try {
      final list = await _reservationRepo.getUserReservations();
      userReservations.assignAll(list);
    } catch (e) {
      appLogger.e('Error loading reservations', error: e);
    } finally {
      isLoading(false);
    }
  }

  void setPlace(PlaceModel place) {
    selectedPlace.value = place;
  }

  void incrementVisitors() {
    if (visitorCount.value < 10) visitorCount.value++;
  }

  void decrementVisitors() {
    if (visitorCount.value > 1) visitorCount.value--;
  }

  double get totalPrice {
    final place = selectedPlace.value;
    if (place == null) return 0;
    return place.ticketPrice * visitorCount.value;
  }

  Future<void> createReservation() async {
    final place = selectedPlace.value;
    if (place == null) {
      Get.snackbar('Error', 'No place selected');
      return;
    }

    isCreating(true);
    try {
      final reservation = await _reservationRepo.createReservation(
        placeId: place.id,
        placeName: place.name,
        selectedDateTime: selectedDateTime.value,
        visitorCount: visitorCount.value,
        price: totalPrice,
      );

      if (totalPrice > 0) {
        final payment = await _paymentRepo.createMockPayment(
          amount: totalPrice,
          currency: 'JPY',
          purpose: 'Reservation: ${place.name}',
          relatedReservationId: reservation.id,
        );
        await _reservationRepo.confirmPayment(reservation.id);
        appLogger.i('Mock payment ${payment.id} processed');
      }

      lastCreatedReservation.value = reservation;
      await loadUserReservations();
      Get.snackbar('Confirmed!', 'Reservation for ${place.name} is confirmed.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      appLogger.e('Error creating reservation', error: e);
      Get.snackbar('Error', 'Could not create reservation: $e');
    } finally {
      isCreating(false);
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    try {
      await _reservationRepo.cancelReservation(reservationId);
      await loadUserReservations();
      Get.snackbar('Cancelled', 'Reservation has been cancelled.');
    } catch (e) {
      appLogger.e('Error cancelling reservation', error: e);
      Get.snackbar('Error', 'Could not cancel: $e');
    }
  }
}
