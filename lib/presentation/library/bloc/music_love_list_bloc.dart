import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'music_love_list_event.dart';
import 'music_love_list_state.dart';

class MusicLoveListBloc extends Bloc<MusicLoveListEvent, MusicLoveListState> {
  final ApiService apiService;

  MusicLoveListBloc(this.apiService) : super(MusicLoveListInitial()) {
    on<FetchMusicLoveListEvent>(_onFetchMusicLoveList);
  }

  Future<void> _onFetchMusicLoveList(
      FetchMusicLoveListEvent event, Emitter<MusicLoveListState> emit) async {
    emit(MusicLoveListLoading());

    try {
      final response = await apiService.get('musics/getMusicLove');
      print("Response: $response");

      if (response["status"] == 200 && response["success"] == true) {
        final List<dynamic> data = response["data"];
        final List<Map<String, dynamic>> musicList = List<Map<String, dynamic>>.from(data);

        // Lưu danh sách "_id" vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final musicIds = musicList.map((music) => music["_id"] as String).toList();
        await prefs.setStringList('musicLoveIds', musicIds);

        print(
          "Music love list fetched successfully: ${musicList}");
        emit(MusicLoveListLoaded(musicList));
      } else {
        emit(MusicLoveListError("Failed to fetch music love list: ${response['message']}"));
      }
    } catch (e) {
      emit(MusicLoveListError("Error: $e"));
    }
  }
}