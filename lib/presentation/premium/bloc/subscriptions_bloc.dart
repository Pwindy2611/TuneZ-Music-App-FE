import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_event.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_state.dart';
class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  ApiService apiService;

  SubscriptionsBloc(this.apiService) : super(SubscriptionsInitial()) {
    on<FetchSubscriptions>(_onFetchSubscriptions);
  }

  Future<void> _onFetchSubscriptions(
    FetchSubscriptions event, Emitter<SubscriptionsState> emit) async {
  emit(SubscriptionsLoading());
  try {
    final response = await apiService.get('subscriptions/getAllSubscriptions');

    if (kDebugMode) {
      print("API Response: $response");
    }

    if (response["status"] == 200 && response["data"] != null) {
      final List<dynamic> subscriptions = response["data"];
      
      emit(SubscriptionsLoaded(subscriptions: subscriptions));
    } else {
      emit(SubscriptionsFailure(errorMessage: "Lỗi khi lấy danh sách subscriptions: ${response["message"] ?? 'Không xác định'}"));
    }
  } catch (e) {
     emit(SubscriptionsFailure(errorMessage: "Lỗi kết nối: $e"));
  }
}
}
