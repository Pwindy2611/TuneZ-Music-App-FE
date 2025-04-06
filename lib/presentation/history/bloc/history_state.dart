abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List tracks;
  HistoryLoaded(this.tracks);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}

class NoHistory extends HistoryState {}