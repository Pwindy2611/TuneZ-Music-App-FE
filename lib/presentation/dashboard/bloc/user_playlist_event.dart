abstract class HomePlaylistEvent {}

class FetchHomePlaylistEvent extends HomePlaylistEvent {
  final String userId;
  FetchHomePlaylistEvent(this.userId);
}

// New event to reset the state
class ResetHomePlaylistStateEvent extends HomePlaylistEvent {}
