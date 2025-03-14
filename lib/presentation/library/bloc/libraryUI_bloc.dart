import 'package:flutter_bloc/flutter_bloc.dart';
import 'libraryUI_state.dart';

class LibraryUIBloc extends Cubit<LibraryState> {
  LibraryUIBloc() : super(const LibraryState());

  void toggleViewMode() {
    emit(state.copyWith(isGridView: !state.isGridView));
  }
}
