abstract class UserPlaylistState {}

class UserPlaylistLoading extends UserPlaylistState {}

class UserPlaylistLoaded extends UserPlaylistState {
  final List<dynamic> playlist;
  UserPlaylistLoaded(this.playlist);
}

class UserPlaylistError extends UserPlaylistState {
  final String message;
  UserPlaylistError(this.message);
}
