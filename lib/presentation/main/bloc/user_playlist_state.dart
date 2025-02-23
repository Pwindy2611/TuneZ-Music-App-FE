abstract class UserPlaylistState {}

class UserPlaylistLoading extends UserPlaylistState {}

class UserPlaylistLoaded extends UserPlaylistState {
  final Map<String, List<dynamic>> playlist;
  UserPlaylistLoaded(this.playlist);
}

class UserPlaylistError extends UserPlaylistState {
  final String message;
  UserPlaylistError(this.message);
}
