import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'artist_follow_event.dart';
import 'artist_follow_state.dart';
import 'package:tunezmusic/data/services/api_service.dart';

class ArtistFollowBloc extends Bloc<ArtistFollowEvent, ArtistFollowState> {
  final ApiService apiService;

  ArtistFollowBloc(this.apiService) : super(ArtistFollowInitial()) {
    on<FetchArtistFollowEvent>(_fetchArtistFollow);
  }

  Future<void> _fetchArtistFollow(
      FetchArtistFollowEvent event, Emitter<ArtistFollowState> emit) async {
    try {
      final response = await apiService.get("follow/getFollowingUsers");
      if (response != null && response.containsKey("data")) {
        final artistsData = response["data"];

        if (artistsData is List<dynamic>) {
          final List<Map<String, dynamic>> allArtists =
              artistsData.map((artist) {
            return {
              "name": artist["name"],
              "img": artist["profileImage"],
              "followers":
                  artist["followerCount"],
            };
          }).toList();
          emit(ArtistFollowLoaded(allArtists));
        }
      } else {
        emit(ArtistFollowLoaded([]));
      }
    } catch (e) {
      if (kDebugMode) {
        print("ArtistFollow Error: ${e.toString()}");
      }
      emit(ArtistFollowError(e.toString()));
    }
  }
}
