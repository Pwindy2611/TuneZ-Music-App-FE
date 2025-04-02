import 'package:equatable/equatable.dart';

abstract class MusicLoveState extends Equatable {
  const MusicLoveState();

  @override
  List<Object?> get props => [];
}

class MusicLoveInitial extends MusicLoveState {}

class MusicLoveLoading extends MusicLoveState {}

class MusicLoveSuccess extends MusicLoveState {}

class MusicLoveFailure extends MusicLoveState {
  final String error;

  const MusicLoveFailure(this.error);

  @override
  List<Object?> get props => [error];
}