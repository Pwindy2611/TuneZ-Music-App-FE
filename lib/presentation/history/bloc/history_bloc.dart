import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ApiService apiService;

  HistoryBloc(this.apiService) : super(HistoryLoading()) {
    on<FetchHistoryEvent>(_fetchHistory);
  }

  Future<void> _fetchHistory(
      FetchHistoryEvent event, Emitter<HistoryState> emit) async {
    try {
      final response = await apiService.get("musics/getMusicHistory");

      if (kDebugMode) {
        print("Response from API: $response");
      }

      if (response["status"] == 200 && response.containsKey("data")) {
        List<Map<String, dynamic>> playlists =
            List<Map<String, dynamic>>.from(response["data"]);

        if (kDebugMode) {
          debugPrint("Processed Playlists: $playlists");
        }
        print("playlistHistory: $playlists");

        emit(HistoryLoaded(playlists));
      }else {
           emit(NoHistory());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Fetch History Error: $e");
      }
         emit(NoHistory());
    }
  }
}
