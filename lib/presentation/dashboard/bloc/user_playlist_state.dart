abstract class HomePlaylistState {}

class HomePlaylistInitial extends HomePlaylistState {}
class HomePlaylistLoading extends HomePlaylistState {}

class HomePlaylistLoaded extends HomePlaylistState {
  final List playlist;
  HomePlaylistLoaded(this.playlist);
}

class HomePlaylistError extends HomePlaylistState {
  final String message;
  HomePlaylistError(this.message);
}
