import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/credit_transaction_model.dart';
import 'package:tourism_app/data/repositories/credit_repository.dart';

class CreditController extends GetxController {
  final _creditRepo = CreditRepository();

  final RxList<CreditTransactionModel> transactions =
      <CreditTransactionModel>[].obs;
  final RxInt currentBalance = 0.obs;
  final RxBool isLoading = false.obs;

  final List<Map<String, dynamic>> redemptionOffers = [
    {
      'id': 'offer_souvenir',
      'title': '10% Souvenir Discount',
      'description': 'Use at participating shops',
      'cost': 50,
      'icon': '🛍️',
    },
    {
      'id': 'offer_museum',
      'title': 'Free Museum Entry',
      'description': 'One-time entry to partner museums',
      'cost': 100,
      'icon': '🏛️',
    },
    {
      'id': 'offer_transport',
      'title': 'Free Day Pass – Transport',
      'description': '24-hour unlimited metro/bus',
      'cost': 80,
      'icon': '🚇',
    },
    {
      'id': 'offer_food',
      'title': '15% Restaurant Discount',
      'description': 'Valid at partner restaurants',
      'cost': 60,
      'icon': '🍜',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCreditData();
  }

  Future<void> fetchCreditData() async {
    isLoading(true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final balance = await _creditRepo.getBalance(uid);
      final txList = await _creditRepo.getTransactions(uid);

      currentBalance.value = balance;
      transactions.assignAll(txList);
      appLogger.i('Credit data loaded: balance=$balance, txns=${txList.length}');
    } catch (e) {
      appLogger.e('Error loading credit data', error: e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> redeemCredits(String offerId, int cost) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (currentBalance.value < cost) {
      Get.snackbar('Insufficient Credits',
          'You need $cost credits for this offer. You have ${currentBalance.value}.');
      return;
    }

    try {
      final offer =
          redemptionOffers.firstWhere((o) => o['id'] == offerId, orElse: () => {});
      if (offer.isEmpty) return;

      await _creditRepo.addTransaction(
        userId: uid,
        amount: -cost,
        type: CreditTransactionType.redemption,
        reason: 'Redeemed: ${offer['title']}',
        source: 'app',
      );

      currentBalance.value -= cost;
      await fetchCreditData();
      Get.snackbar('Redeemed!', '${offer['title']} – enjoy your reward!');
    } catch (e) {
      appLogger.e('Error redeeming credits', error: e);
      Get.snackbar('Error', 'Could not redeem: $e');
    }
  }
}
