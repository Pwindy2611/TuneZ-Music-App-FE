abstract class ArtistFollowState {}

class ArtistFollowLoading extends ArtistFollowState {}

class ArtistFollowLoaded extends ArtistFollowState {
  final List<dynamic> artistList;
  ArtistFollowLoaded(this.artistList);
}

class ArtistFollowError extends ArtistFollowState {
  final String message;
  ArtistFollowError(this.message);
}
