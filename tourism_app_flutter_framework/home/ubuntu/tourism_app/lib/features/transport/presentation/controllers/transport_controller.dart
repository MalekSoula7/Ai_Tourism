import 'package:get/get.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/transport_station_model.dart';
import 'package:tourism_app/data/repositories/payment_repository.dart';
import 'package:tourism_app/data/repositories/transport_repository.dart';

class TransportController extends GetxController {
  final _transportRepo = TransportRepository();
  final _paymentRepo = PaymentRepository();

  final RxList<TransportStationModel> stations = <TransportStationModel>[].obs;
  final RxList<TransportTicketModel> userTickets = <TransportTicketModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPurchasing = false.obs;
  final Rx<TransportStationModel?> selectedStation =
      Rx<TransportStationModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStations();
    loadUserTickets();
  }

  Future<void> loadStations() async {
    isLoading(true);
    try {
      final list = await _transportRepo.getStations();
      stations.assignAll(list);
    } catch (e) {
      appLogger.e('Error loading stations', error: e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadUserTickets() async {
    try {
      final list = await _transportRepo.getUserTickets();
      userTickets.assignAll(list);
    } catch (e) {
      appLogger.e('Error loading tickets', error: e);
    }
  }

  void selectStation(TransportStationModel station) {
    selectedStation.value = station;
  }

  Future<void> purchaseTicket(String ticketType, double price) async {
    final station = selectedStation.value;
    if (station == null) return;

    isPurchasing(true);
    try {
      if (price > 0) {
        await _paymentRepo.createMockPayment(
          amount: price,
          currency: 'JPY',
          purpose: '$ticketType – ${station.name}',
        );
      }

      final ticket = await _transportRepo.purchaseTicket(
        stationId: station.id,
        stationName: station.name,
        ticketType: ticketType,
      );

      userTickets.insert(0, ticket);
      Get.snackbar(
        'Ticket Purchased!',
        '$ticketType valid for 24h from now.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      appLogger.e('Error purchasing ticket', error: e);
      Get.snackbar('Error', 'Could not purchase ticket: $e');
    } finally {
      isPurchasing(false);
    }
  }
}
