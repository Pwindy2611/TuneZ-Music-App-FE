abstract class ArtistFollowEvent {}

class FetchArtistFollowEvent extends ArtistFollowEvent {
  final String userId;
  FetchArtistFollowEvent(this.userId);
}
