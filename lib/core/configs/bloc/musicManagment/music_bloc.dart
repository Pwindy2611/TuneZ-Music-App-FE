// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'music_event.dart';
import 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService apiService;
  StreamSubscription? _positionSubscription;
  List<String> playlist = []; // Danh sách phát
  int currentIndex = 0; // Chỉ số bài hát hiện tại
  PlayerState? _previousState;
  MusicBloc(this.apiService) : super(MusicInitial()) {
    on<LoadUserMusicState>(_onLoadUserMusicState);
    on<PlayStreamMusic>(_onPlayMusicOnFirst);
    on<PauseMusic>(_onPauseMusic);
    on<SeekMusic>(_onSeekMusic);
    on<PlayMusic>(_playMusic);
    on<UpdatePosition>(_onUpdatePosition);
    on<UpdatePlaylist>(_onUpdatePlaylist);
    _loadPlaylistFromSharedPreferences();
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (state is MusicLoaded) {
        add(UpdatePosition(position: position));
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) async {
      if (state is! MusicLoaded) return;
      final currentState = state as MusicLoaded;

      // Chỉ gọi API khi trạng thái thực sự thay đổi
      if (_previousState?.playing != playerState.playing) {
        _previousState = playerState;

        if (_audioPlayer.playing) {
          final updateStatePlay = await apiService.postWithCookies(
              'musics/playMusic/${currentState.currentMusicId}', {});
          if (updateStatePlay["status"] == 200) {
            print("Cập nhật trạng thái phát nhạc thành công trên server.");
            final duration = _audioPlayer.duration ?? Duration.zero;
            final position = _audioPlayer.position;

            emit(currentState.copyWith(
              currentMusicId: currentState.currentMusicId,
              isPlaying: true,
              duration: duration,
              position: position,
            ));
          }
        } else {
          final response =
              await apiService.postWithCookies('musics/pauseMusic', {});
          if (response["status"] == 200) {
            print("Cập nhật trạng thái pause nhạc thành công trên server.");
            emit(currentState.copyWith(isPlaying: false));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }

  Future<void> _loadPlaylistFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistString = prefs.getString('playlist_tracks');
    if (playlistString != null) {
      playlist = List<String>.from(jsonDecode(playlistString));
      if (kDebugMode) {
        print("Playlist: $playlist");
      }
    }
  }

  Future<void> _onUpdatePlaylist(
      UpdatePlaylist event, Emitter<MusicState> emit) async {
    await _loadPlaylistFromSharedPreferences();
  }

  Future<void> _onLoadUserMusicState(
      LoadUserMusicState event, Emitter<MusicState> emit) async {
    final response = await apiService.get('musics/getUserMusicState');
    if (kDebugMode) {
      print(response);
    }
    if (response["status"] == 200) {
      final streamAudio = await apiService.getStream(
          'musics/getStreamMusic/${response['state']['currentMusicId']}');

      if (streamAudio?.statusCode == 200) {
        final audioBytes = await streamAudio!.stream.fold<Uint8List>(
          Uint8List(0),
          (previous, element) => Uint8List.fromList([...previous, ...element]),
        );
        final audioSource = AudioSource.uri(
          Uri.parse('data:audio/mp3;base64,${base64Encode(audioBytes)}'),
          tag: MediaItem(
            id: response['state']['currentMusicId'],
            album: "Album",
            title: "Title",
            artist: "Artist",
            artUri: Uri.parse(
                "https://res.cloudinary.com/doxgamppz/image/upload/v1741004370/music-storage/files/-OKQwablya3-O5gS7c4-/theflob.png"),
          ),
        );
        await _audioPlayer.setAudioSource(audioSource);
        await _audioPlayer.load();
        await Future.delayed(Duration(milliseconds: 500));
        final currentMusicId = response['state']['currentMusicId'];
        final isPlaying = response['state']['isPlaying'];
        final position =
            Duration(seconds: (response['state']['timestamp'] ?? 0).toInt());
        final duration = _audioPlayer.duration ?? Duration.zero;
        emit(MusicLoaded(
          currentMusicId: currentMusicId,
          isPlaying: isPlaying,
          duration: duration,
          position: position,
          musicUrl: null,
        ));
        await _audioPlayer.seek(position);
        add(UpdatePosition(position: position));
      }
    } else {
      emit(MusicNewAccount());
    }
  }

  Future<void> _onPlayMusicOnFirst(
      PlayStreamMusic event, Emitter<MusicState> emit) async {
    try {
      final response =
          await apiService.getStream('musics/getStreamMusic/${event.musicId}');

      if (response?.statusCode == 200) {
        final audioBytes = await response!.stream.fold<Uint8List>(
          Uint8List(0),
          (previous, element) => Uint8List.fromList([...previous, ...element]),
        );
        final audioSource = AudioSource.uri(
          Uri.parse('data:audio/mp3;base64,${base64Encode(audioBytes)}'),
          tag: MediaItem(
              id: event.musicId,
              album: "Album",
              title: "Title",
              artist: "Artist",
              artUri: Uri.parse(
                  "https://res.cloudinary.com/doxgamppz/image/upload/v1741006711/music-storage/files/-OKR4XE1EW2njsGEM2Yh/tangai505.jpg")),
        );

        await _audioPlayer.setAudioSource(audioSource);
        await _audioPlayer.load();
        await Future.delayed(Duration(milliseconds: 500));
        if (state is MusicLoaded) {
          final currentState = state as MusicLoaded;
          emit(currentState.copyWith(
            currentMusicId: event.musicId,
            isPlaying: true,
            position: Duration.zero, // Reset vị trí phát nhạc
          ));
        } else {
          emit(MusicLoaded(
            currentMusicId: event.musicId,
            isPlaying: true,
            duration: _audioPlayer.duration ?? Duration.zero,
            position: Duration.zero,
          ));
        }
        await _audioPlayer.play(); // Phát nhạc ngay
      }
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
    }
  }

  Future<void> _onPauseMusic(PauseMusic event, Emitter<MusicState> emit) async {
    if (state is MusicLoaded) {
      await _audioPlayer.pause();
    }
  }

  Future<void> _playMusic(PlayMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi gửi yêu cầu phát nhạc lên server: $e");
      }
    }
  }

  Future<void> _onSeekMusic(SeekMusic event, Emitter<MusicState> emit) async {
    await _audioPlayer.seek(event.position);
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(currentState.copyWith(position: event.position));
    }
  }

  Future<void> _onUpdatePosition(
      UpdatePosition event, Emitter<MusicState> emit) async {
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(currentState.copyWith(position: event.position));
    }
  }

  Future<void> _playNext() async {
    if (playlist.isNotEmpty) {
      final random = Random();
      final nextIndex = random.nextInt(playlist.length);
      final nextMusicId = playlist[nextIndex];
      add(PlayStreamMusic(musicId: nextMusicId));
    }
  }
}
