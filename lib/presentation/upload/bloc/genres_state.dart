abstract class GenresState {}

class GenresInitial extends GenresState {}

class GenresLoading extends GenresState {}

class GenresLoaded extends GenresState {
  final List<dynamic> genres;

  GenresLoaded(this.genres);
}

class GenresError extends GenresState {
  final String message;

  GenresError(this.message);
} 