abstract class ThrowbackPlaylistEvent {}

class FetchThrowbackPlaylistEvent extends ThrowbackPlaylistEvent {
  final String userId;
  FetchThrowbackPlaylistEvent(this.userId);
}
