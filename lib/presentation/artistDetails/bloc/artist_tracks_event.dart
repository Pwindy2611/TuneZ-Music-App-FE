import 'package:equatable/equatable.dart';

abstract class ArtistTracksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchArtistTracks extends ArtistTracksEvent {
  final String artistName;

  FetchArtistTracks({required this.artistName});

  @override
  List<Object?> get props => [artistName];
}