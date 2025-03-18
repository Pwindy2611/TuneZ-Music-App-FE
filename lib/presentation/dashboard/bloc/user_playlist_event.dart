abstract class HomePlaylistEvent {}

class FetchHomePlaylistEvent extends HomePlaylistEvent {
  final String userId;
  FetchHomePlaylistEvent(this.userId);
}
