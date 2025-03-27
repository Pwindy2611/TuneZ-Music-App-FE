// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
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
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playbackStateSubscription;
  List<dynamic> playlist = [];
  PlayerState? _previousState;
  bool _isNextCalled = false;
  MusicBloc(this.apiService) : super(MusicInitial()) {
    on<LoadUserMusicState>(_onLoadUserMusicState);
    on<PlayStreamMusic>(_onPlayMusicOnFirst);
    on<PauseMusic>(_onPauseMusic);
    on<SeekMusic>(_onSeekMusic);
    on<PlayMusic>(_playMusic);
    on<UpdatePosition>(_onUpdatePosition);
    on<UpdatePlaylist>(_onUpdatePlaylist);
    on<RanDomTrackEvent>(_randomTrack);
    on<LogoutEvent>(_onLogout);
    _setupEventListeners();
  }

  void _setupEventListeners() {
    // Position listener
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        emit(currentState.copyWith(position: position));
        // _handleSeelStateChange(currentState, position);
      }
    });

    // Completion listener
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (state is! MusicNewAccount) {
          final currentState = state as MusicLoaded;
          if (currentState.isPlaying) {
            _audioPlayer.pause();
          }
        }
        if (!_isNextCalled) {
          _isNextCalled = true;
          final currentState = state as MusicLoaded;
          _playNext(currentState);
          Future.delayed(
              const Duration(milliseconds: 500), () => _isNextCalled = false);
        }
      }
    });

    // Playback state listener
    _playbackStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) async {
      if (state is! MusicLoaded) return;
      final currentState = state as MusicLoaded;

      // Only handle state changes if the playing state actually changed
      if (_previousState?.playing != playerState.playing ||
          _previousState == null) {
        _previousState = playerState;
        await _handlePlaybackStateChange(currentState, playerState);
      }
    });

    // Add seek position listener
    _audioPlayer.positionStream.listen((position) async {
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        await _handleSeelStateChange(currentState, position);
      }
    });
  }

  Future<void> _handleSeelStateChange(
      MusicLoaded currentState, Duration position) async {
    try {
      final response = await apiService.postWithCookies(
        'musics/seekMusic/${currentState.currentMusicId}?seek=${position.inSeconds}',
        {},
      );
      if (response["status"] == 200) {
        print("Cập nhật vị trí seek nhạc thành công trên server.");
      }
    } catch (e) {
      print("Lỗi khi cập nhật vị trí seek nhạc: $e");
    }
  }

  Future<void> _handlePlaybackStateChange(
      MusicLoaded currentState, PlayerState playerState) async {
    if (playerState.playing) {
      final updateStatePlay = await apiService.postWithCookies(
          'musics/playMusic/${currentState.currentMusicId}', {});
      if (updateStatePlay["status"] == 200) {
        final duration = _audioPlayer.duration ?? Duration.zero;
        final position = _audioPlayer.position;

        emit(currentState.copyWith(
          isPlaying: true,
          duration: duration,
          position: position,
        ));
        print("Cập nhật trạng thái phát nhạc thành công trên server.");
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

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playbackStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onUpdatePlaylist(
      UpdatePlaylist event, Emitter<MusicState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy playlist hiện tại từ SharedPreferences
    final String? savedPlaylistJson = prefs.getString('playlist');
    List<dynamic> savedPlaylist = [];

    if (savedPlaylistJson != null) {
      try {
        // Giải mã JSON thành danh sách List<dynamic>
        final List<dynamic> decodedJson = json.decode(savedPlaylistJson);
        savedPlaylist = decodedJson;
      } catch (e) {
        print("Lỗi khi giải mã playlist từ SharedPreferences: $e");
      }
    }

    // So sánh playlist mới với playlist đã lưu
    if (!listEquals(event.allTracks, savedPlaylist)) {
      playlist = event.allTracks;

      // Lưu playlist mới vào SharedPreferences
      await prefs.setString('playlist', json.encode(playlist));
      print("Playlist updated & saved: $playlist");
    } else {
      print("Playlist không thay đổi, không cần lưu.");
    }
  }

  Future<void> _onLoadUserMusicState(
      LoadUserMusicState event, Emitter<MusicState> emit) async {
    emit(MusicLoading());

    final response = await apiService.get('musics/getUserMusicState');
    if (kDebugMode) print(response);

    if (response["status"] != 200) {
      emit(MusicNewAccount());
      return;
    }

    final currentMusicId = response['state']['currentMusicId'];
    final isPlaying = response['state']['isPlaying'];
    final position =
        Duration(seconds: (response['state']['timestamp'] ?? 0).toInt());
    print(position);

    // Không chờ mà lấy stream nhạc song song
    final streamFuture =
        apiService.getStream('musics/getStreamMusic/$currentMusicId');

    final streamAudio = await streamFuture;
    if (streamAudio?.statusCode != 200) {
      emit(MusicNewAccount());
      return;
    }
    final infoTracks =
        await apiService.get('musics/getMusicInfo/$currentMusicId');

    if (infoTracks['status'] != 200) {
      emit(MusicNewAccount());
      return;
    }
    final data = infoTracks['data'];
    final imgTracks = data['imgPath'];
    final nameTracks = data['name'];
    final artistTracks = data['artist'];

    // Dùng BytesBuilder thay vì fold() để tối ưu hiệu suất
    final bytesBuilder = BytesBuilder();
    await for (final chunk in streamAudio!.stream) {
      bytesBuilder.add(chunk);
    }
    final audioBytes = bytesBuilder.toBytes();

    final audioSource = AudioSource.uri(
      Uri.parse('data:audio/mp3;base64,${base64Encode(audioBytes)}'),
      tag: MediaItem(
        id: currentMusicId,
        album: nameTracks,
        title: nameTracks,
        artist: artistTracks,
        artUri: Uri.parse(imgTracks),
      ),
    );

    // Đặt nguồn phát nhưng không cần chờ `load()`
    await _audioPlayer.setAudioSource(audioSource);
    await _audioPlayer.load();
    Duration? duration;
    while (duration == null) {
      await Future.delayed(const Duration(milliseconds: 200));
      duration = _audioPlayer.duration;
    }
    emit(MusicLoaded(
      name: nameTracks,
      artist: artistTracks,
      currentMusicId: currentMusicId,
      isPlaying: isPlaying,
      duration: duration,
      position: position,
      musicUrl: imgTracks,
    ));
    _audioPlayer.seek(position);
    add(UpdatePosition(position: position));
  }

  Future<void> _onPlayMusicOnFirst(
      PlayStreamMusic event, Emitter<MusicState> emit) async {
    try {
      final response =
          await apiService.getStream('musics/getStreamMusic/${event.musicId}');
      if (response?.statusCode == 200) {
        print('Load stream music success');
        final infoTracks =
            await apiService.get('musics/getMusicInfo/${event.musicId}');

        if (infoTracks['status'] != 200) {
          return;
        }
        final data = infoTracks['data'];
        final imgTracks = data['imgPath'];
        final nameTracks = data['name'];
        final artistTracks = data['artist'];
        emit(MusicLoaded(
          name: nameTracks,
          artist: artistTracks,
          currentMusicId: event.musicId,
          isPlaying: false,
          duration: _audioPlayer.duration ?? Duration.zero, // Tránh null
          position: Duration.zero,
          musicUrl: imgTracks,
        ));
        final bytesBuilder = BytesBuilder();
        await for (final chunk in response!.stream) {
          bytesBuilder.add(chunk);
          print("Nhận được ${chunk.length} bytes từ stream");
        }
        final audioBytes = bytesBuilder.toBytes();

        final audioSource = AudioSource.uri(
          Uri.parse('data:audio/mp3;base64,${base64Encode(audioBytes)}'),
          tag: MediaItem(
            id: event.musicId,
            album: nameTracks,
            title: nameTracks,
            artist: artistTracks,
            artUri: Uri.parse(imgTracks),
          ),
        );
        // Đặt nguồn phát không cần chờ load()
        await _audioPlayer.setAudioSource(audioSource);
        await _audioPlayer.load();
        _audioPlayer.play();
      } else {
        print("Lỗi tải stream nhạc: StatusCode ${response?.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
    }
  }

  Future<void> _onPauseMusic(PauseMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi gửi yêu cầu tạm dừng nhạc lên server: $e");
      }
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
    try {
      await _audioPlayer.seek(event.position);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi seek nhạc: $e");
      }
    }
  }

  Future<void> _onUpdatePosition(
      UpdatePosition event, Emitter<MusicState> emit) async {
    if (state is MusicLoaded) {
      final currentState = state as MusicLoaded;
      emit(currentState.copyWith(position: event.position));
    }
  }

  Future<void> _playNext(MusicLoaded currentState) async {
    // Nếu playlist rỗng, lấy từ SharedPreferences
    if (playlist.isEmpty) {
      await _loadPlaylistFromStorage();
    }

    if (playlist.isNotEmpty) {
      final random = Random();

      if (playlist.length == 1) {
        add(PlayStreamMusic(musicId: playlist[0]));
        return;
      }

      String nextMusicId;
      do {
        nextMusicId = playlist[random.nextInt(playlist.length)];
      } while (nextMusicId == currentState.currentMusicId);

      print("Next music: $nextMusicId");
      add(PlayStreamMusic(musicId: nextMusicId));
    } else {
      print("Playlist vẫn trống, không thể phát nhạc.");
    }
  }

  Future<void> _randomTrack(
      RanDomTrackEvent event, Emitter<MusicState> emit) async {
    // Nếu playlist rỗng, lấy từ SharedPreferences
    if (playlist.isEmpty) {
      await _loadPlaylistFromStorage();
    }

    if (playlist.isNotEmpty) {
      final random = Random();

      if (playlist.length == 1) {
        add(PlayStreamMusic(musicId: playlist[0]));
        return;
      }

      String musicId = playlist[random.nextInt(playlist.length)];
      print("Random music: $musicId");
      add(PlayStreamMusic(musicId: musicId));
    } else {
      print("Playlist vẫn trống, không thể phát nhạc.");
    }
  }

  Future<void> _loadPlaylistFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedPlaylistJson = prefs.getString('playlist');

    if (savedPlaylistJson != null) {
      try {
        List<dynamic> loadedPlaylist = json.decode(savedPlaylistJson);
        playlist = loadedPlaylist;
        print("Playlist loaded from SharedPreferences: $playlist");
      } catch (e) {
        print("Lỗi khi giải mã playlist từ SharedPreferences: $e");
      }
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.pause(); // Dừng nhạc nếu đang phát
      await _audioPlayer.stop();
      await _audioPlayer.dispose(); // Giải phóng tài nguyên
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _playbackStateSubscription?.cancel();
      emit(MusicInitial()); // Quay về trạng thái ban đầu
    } catch (e) {
      print("Lỗi khi logout: $e");
    }
  }
}
