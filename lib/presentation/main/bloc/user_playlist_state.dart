abstract class HomePlaylistState {}

class HomePlaylistLoading extends HomePlaylistState {}

class HomePlaylistLoaded extends HomePlaylistState {
  final Map<String, List<dynamic>> playlist;
  HomePlaylistLoaded(this.playlist);
}

class HomePlaylistError extends HomePlaylistState {
  final String message;
  HomePlaylistError(this.message);
}
