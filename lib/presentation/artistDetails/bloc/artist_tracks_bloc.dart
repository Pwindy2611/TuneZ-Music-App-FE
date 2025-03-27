import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'artist_tracks_event.dart';
import 'artist_tracks_state.dart';

class ArtistTracksBloc extends Bloc<ArtistTracksEvent, ArtistTracksState> {
  final ApiService apiService;

   ArtistTracksBloc(this.apiService) : super(ArtistTracksInitial()) {
    on<FetchArtistTracks>(_onFetchArtistTracks);
  }

  Future<void> _onFetchArtistTracks(
      FetchArtistTracks event, Emitter<ArtistTracksState> emit) async {
    emit(ArtistTracksLoading());
    try {
      final response = await apiService.get('musics/getMusicByArtist?artist=${event.artistName}');
      if (response['status'] == 200) {
        final tracks = response['data'];
        print(tracks);
        emit(ArtistTracksLoaded(tracks: tracks));
      } else {
        emit(ArtistTracksError(message: 'Failed to fetch tracks.'));
      }
    } catch (e) {
      emit(ArtistTracksError(message: e.toString()));
    }
  }
}