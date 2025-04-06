import 'package:equatable/equatable.dart';

abstract class ArtistSelectionState extends Equatable {
  const ArtistSelectionState();

  @override
  List<Object?> get props => [];
}

class ArtistSelectionInitialState extends ArtistSelectionState {}
class ArtistSelectionLoadingState extends ArtistSelectionState {}

class ArtistSelectionFetchSuccessState extends ArtistSelectionState {
  final List<dynamic> listArtist;
  const ArtistSelectionFetchSuccessState(this.listArtist);
}

// Trạng thái lỗi
class ArtistSelectionFetchErrorState extends ArtistSelectionState {
  final String message;

  const ArtistSelectionFetchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ArtistSelectionPostLoadingState extends ArtistSelectionState {}

class ArtistSelectionFetchPostState extends ArtistSelectionState {}

class ArtistSelectionPostErrorState extends ArtistSelectionState {
  final String message;

  const ArtistSelectionPostErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class ArtistSelectionInitial extends ArtistSelectionState{}