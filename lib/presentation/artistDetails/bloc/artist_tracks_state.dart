import 'package:equatable/equatable.dart';

abstract class ArtistTracksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArtistTracksInitial extends ArtistTracksState {}

class ArtistTracksLoading extends ArtistTracksState {}

class ArtistTracksLoaded extends ArtistTracksState {
  final List<dynamic> tracks;

  ArtistTracksLoaded({required this.tracks});

  @override
  List<Object?> get props => [tracks];
}

class ArtistTracksError extends ArtistTracksState {
  final String message;

  ArtistTracksError({required this.message});

  @override
  List<Object?> get props => [message];
}