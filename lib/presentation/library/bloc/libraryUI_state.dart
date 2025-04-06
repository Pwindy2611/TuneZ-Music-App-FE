import 'package:equatable/equatable.dart';

class LibraryState extends Equatable {
  final bool isGridView;

  const LibraryState({this.isGridView = false});

  LibraryState copyWith({bool? isGridView}) {
    return LibraryState(
      isGridView: isGridView ?? this.isGridView,
    );
  }

  @override
  List<Object> get props => [isGridView];
}
