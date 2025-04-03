import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MusicLoveListState extends Equatable {
  const MusicLoveListState();

  @override
  List<Object?> get props => [];
}

class MusicLoveListInitial extends MusicLoveListState {}

class MusicLoveListLoading extends MusicLoveListState {}

class MusicLoveListLoaded extends MusicLoveListState {
  final List<Map<String, dynamic>> musicList; // Danh sách nhạc yêu thích

  const MusicLoveListLoaded(this.musicList);

  @override
  List<Object?> get props => [musicList];

  // Phương thức copyWith để cập nhật danh sách nhạc
  MusicLoveListLoaded copyWith({
    List<Map<String, dynamic>>? musicList,
  }) {
    return MusicLoveListLoaded(
      musicList ?? this.musicList,
    );
  }

  // Phương thức để lưu danh sách "_id" vào SharedPreferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final musicIds = musicList.map((music) => music["_id"] as String).toList();
    await prefs.setStringList('musicLoveIds', musicIds);
  }
}

class MusicLoveListError extends MusicLoveListState {
  final String error;

  const MusicLoveListError(this.error);

  @override
  List<Object?> get props => [error];
}