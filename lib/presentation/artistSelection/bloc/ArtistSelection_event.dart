import 'package:equatable/equatable.dart';

abstract class ArtistSelectionEvent extends Equatable {
  const ArtistSelectionEvent();

  @override
  List<Object?> get props => [];
}

class ArtistSelectionPostEvent extends ArtistSelectionEvent {
  final List selectedArtists;

  const ArtistSelectionPostEvent( this.selectedArtists);

  @override
  List<Object?> get props => [selectedArtists];
}

class ArtistSelectionFetchEvent extends ArtistSelectionEvent {}
