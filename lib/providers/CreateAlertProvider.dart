import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/model/CreateAlertModel.dart';

class AlertNotifier extends StateNotifier<AsyncValue<void>> {
  AlertNotifier() : super(const AsyncData(null));

  Future<void> createAlert(CreateAlertModel alert) async {
    state = const AsyncLoading();

    try {
      // TODO: send to API / Firebase / backend
      await Future.delayed(const Duration(seconds: 2));

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final alertProvider =
StateNotifierProvider<AlertNotifier, AsyncValue<void>>((ref) {
  return AlertNotifier();
});
