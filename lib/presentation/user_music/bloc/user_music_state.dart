abstract class UserMusicState {}

class UserMusicInitial extends UserMusicState {}

class UserMusicLoading extends UserMusicState {}

class UserMusicLoaded extends UserMusicState {
  final List tracks;

  UserMusicLoaded(this.tracks);
}
class UserMusicError extends UserMusicState {
  final String message;

  UserMusicError(this.message);
} 