import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'music_event.dart';
import 'music_state.dart';
import 'dart:convert';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService apiService;

  MusicBloc(this.apiService) : super(MusicInitial()) {
    on<LoadUserMusicState>(_onLoadUserMusicState);
    on<PlayMusic>(_onPlayMusic);
    on<PauseMusic>(_onPauseMusic);
    on<SeekMusic>(_onSeekMusic);
  }

  Future<void> _onLoadUserMusicState(
      LoadUserMusicState event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    final response = await apiService.get('musics/getUserMusicState');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      emit(MusicLoaded(
        currentMusicId: data['currentMusicId'],
        isPlaying: data['isPlaying'],
        duration: Duration.zero,
        position: Duration(seconds: data['timestamp'] ?? 0),
        musicUrl: null,
      ));
    }
  }

Future<void> _onPlayMusic(PlayMusic event, Emitter<MusicState> emit) async {
  try {
    final response = await apiService.get('musics/getStreamMusic/${event.musicId}');

    if (response == null) {
      if (kDebugMode) {
        print("Lỗi: Không nhận được phản hồi từ API.");
      }

      return;
    }

    // Kiểm tra kiểu dữ liệu của response
    if (response is String) {
      // Nếu API trả về lỗi hoặc JSON thay vì dữ liệu nhạc
      if (kDebugMode) {
        print("Lỗi: API trả về chuỗi thay vì dữ liệu nhị phân. Dữ liệu: $response");
      }
      return;
    }

    if (!(response.bodyBytes is Uint8List)) {
      if (kDebugMode) {
        print("Lỗi: Dữ liệu trả về không hợp lệ.");
      }
      return;
    }

   final directory = Directory.systemTemp;
    final filePath = '${directory.path}/music_${event.musicId}.mp3';
    final file = File(filePath);

    // Ghi file MP3 vào bộ nhớ tạm
    await file.writeAsBytes(response.bodyBytes);

    // ✅ Phát nhạc từ file đã lưu
    await _audioPlayer.play(DeviceFileSource(filePath));

    emit(MusicLoaded(
      currentMusicId: event.musicId,
      isPlaying: true,
      duration: await _audioPlayer.getDuration() ?? Duration.zero,
      position: await _audioPlayer.getCurrentPosition() ?? Duration.zero,
      musicUrl: filePath,
    ));
  } catch (e) {
    print("Lỗi khi phát nhạc: $e");
  }
}
  Future<void> _onPauseMusic(PauseMusic event, Emitter<MusicState> emit) async {
    await _audioPlayer.pause();
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(currentState.copyWith(isPlaying: false));
    }
  }

  Future<void> _onSeekMusic(SeekMusic event, Emitter<MusicState> emit) async {
    await _audioPlayer.seek(event.position);
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(currentState.copyWith(position: event.position));
    }
  }
}
