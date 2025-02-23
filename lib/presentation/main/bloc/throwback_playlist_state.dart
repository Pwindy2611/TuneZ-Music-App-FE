abstract class ThrowbackPlaylistState {}

class ThrowbackPlaylistLoading extends ThrowbackPlaylistState {}

class ThrowbackPlaylistLoaded extends ThrowbackPlaylistState {
  final List<dynamic> playlist;
  ThrowbackPlaylistLoaded(this.playlist);
}

class ThrowbackPlaylistError extends ThrowbackPlaylistState {
  final String message;
  ThrowbackPlaylistError(this.message);
}
