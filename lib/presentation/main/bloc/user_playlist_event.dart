abstract class UserPlaylistEvent {}

class FetchUserPlaylistEvent extends UserPlaylistEvent {
  final String userId;
  FetchUserPlaylistEvent(this.userId);
}
