abstract class ArtistFollowEvent {}

class FetchArtistFollowEvent extends ArtistFollowEvent {
  final String userId;
  FetchArtistFollowEvent(this.userId);
}

// New event to reset state
class ResetArtistFollowStateEvent extends ArtistFollowEvent {}
