import 'package:flutter_bloc/flutter_bloc.dart';
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

// Trạng thái điều hướng
class NavigationState {
  final int selectedIndex;
  final PlayListDetail? playlistDetail;

  NavigationState({required this.selectedIndex, this.playlistDetail});
}

class ClosePlaylistDetailEvent extends NavigationEvent {}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(selectedIndex: 0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(NavigationState(selectedIndex: event.index));
    });

    on<OpenPlaylistDetailEvent>((event, emit) {
      emit(NavigationState(selectedIndex: 4, playlistDetail: PlayListDetail(playlist: event.playlist)));
    });

    on<ClosePlaylistDetailEvent>((event, emit) {
      emit(NavigationState(selectedIndex: 0)); // Trở lại trang chính
    });
  }
}
