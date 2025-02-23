abstract class RecentPlaylistEvent {}

class FetchRecentPlaylistEvent extends RecentPlaylistEvent {
  final String userId;
  FetchRecentPlaylistEvent(this.userId);
}
