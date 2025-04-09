import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/presentation/artistDetails/pages/artist_playlist_details.dart';
import 'package:tunezmusic/presentation/playlistDetail/pages/playlistDetail.dart';

// Sự kiện điều hướng
abstract class NavigationEvent {}

class ChangeTabEvent extends NavigationEvent {
  final int index;
  ChangeTabEvent(this.index);
}

class OpenPlaylistDetailEvent extends NavigationEvent {
  final Map playlist;
  OpenPlaylistDetailEvent(this.playlist);
}

class OpenArtistDetailEvent extends NavigationEvent {
  final String imgURL;
  final String nameArtist;
  OpenArtistDetailEvent(this.imgURL, this.nameArtist);
}

class OpenHistoryEvent extends NavigationEvent {}

class OpenUserMusicEvent extends NavigationEvent {}

class OpenLovePLaylistEvent extends NavigationEvent {}

class OpenSearchEvent extends NavigationEvent {}

class ResetNavigationStateEvent extends NavigationEvent {}

// Trạng thái điều hướng
class NavigationState {
  final int selectedIndex;
  final PlayListDetail? playlistDetail;
  final ArtistPlayListDetail? artistDetail;

  NavigationState({
    required this.selectedIndex,
    this.playlistDetail,
    this.artistDetail,
  });
}

class ClosePlaylistDetailEvent extends NavigationEvent {}

class BackToLiEvent extends NavigationEvent {}

class BackToSearchEvent extends NavigationEvent {}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(selectedIndex: 0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: event.index,
      ));
    });

    on<OpenPlaylistDetailEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 8,
        playlistDetail: PlayListDetail(playlist: event.playlist),
        artistDetail: state.artistDetail,
      ));
    });

    on<ClosePlaylistDetailEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 0,
      )); 
    });

    on<BackToLiEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 2,
      )); 
    });

    on<BackToSearchEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 1,
      )); 
    });

    on<OpenHistoryEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 4,
      )); 
    });

    on<OpenUserMusicEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 7,
      )); 
    });


    on<OpenArtistDetailEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 9,
        playlistDetail: state.playlistDetail,
        artistDetail: ArtistPlayListDetail(
          imgURL: event.imgURL,
          nameArtist: event.nameArtist,
        ),
      ));
    });

    on<OpenLovePLaylistEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 5,
      )); 
    });

    on<OpenSearchEvent>((event, emit) {
      emit(NavigationState(
        selectedIndex: 6,
      )); 
    });

    on<ResetNavigationStateEvent>(_onResetState);
  }

  void _onResetState(ResetNavigationStateEvent event, Emitter<NavigationState> emit) {
    emit(NavigationState(selectedIndex: 0));
  }
}
