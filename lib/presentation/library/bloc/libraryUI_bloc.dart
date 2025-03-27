import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'libraryUI_state.dart';

class LibraryUIBloc extends Cubit<LibraryState> {
  LibraryUIBloc() : super(const LibraryState()) {
    _loadViewMode();
  }

  // Tải trạng thái từ SharedPreferences khi khởi động
  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isGridView = prefs.getBool('isGridView') ?? false;
    emit(LibraryState(isGridView: isGridView));
  }

  // Chuyển đổi chế độ và lưu vào SharedPreferences
  Future<void> toggleViewMode() async {
    final newState = !state.isGridView;
    emit(state.copyWith(isGridView: newState));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGridView', newState);
  }
}
