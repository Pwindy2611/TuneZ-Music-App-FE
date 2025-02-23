abstract class RecentPlaylistState {}

class RecentPlaylistLoading extends RecentPlaylistState {}

class RecentPlaylistLoaded extends RecentPlaylistState {
  final List<dynamic> playlist;
  RecentPlaylistLoaded(this.playlist);
}

class RecentPlaylistError extends RecentPlaylistState {
  final String message;
  RecentPlaylistError(this.message);
}
