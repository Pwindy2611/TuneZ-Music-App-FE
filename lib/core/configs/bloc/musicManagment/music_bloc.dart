// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_bloc.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_event.dart';
import 'music_event.dart';
import 'music_state.dart';
import 'package:path_provider/path_provider.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService apiService;
  final MusicLoveBloc musicLoveBloc;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playbackStateSubscription;
  List<dynamic> playlist = [];
  PlayerState? _previousState;
  bool _isNextCalled = false;
  bool _isInitialized = false;

  MusicBloc(this.apiService, this.musicLoveBloc) : super(MusicInitial()) {
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
    // Cancel existing subscriptions
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playbackStateSubscription?.cancel();

    // Position listener
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        emit(currentState.copyWith(position: position));
        _handleSeelStateChange(currentState, position);
      }
    });

    // Completion listener
    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
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
  }

  Future<void> _handleSeelStateChange(
      MusicLoaded currentState, Duration position) async {
    try {
      await apiService.postWithCookies(
        'musics/seekMusic/${currentState.currentMusicId}?seek=${position.inSeconds}',
        {},
      );
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

  String _processLyrics(String rawLyrics) {
  // Tách lời bài hát bằng '\n' và nối lại với các dòng xuống dòng cho giao diện hiển thị
  return rawLyrics
      .split('\\n') // Tách chuỗi bằng ký tự '\n'
      .join('\n\n');  // Nối lại bằng ký tự xuống dòng
}

  Future<void> _onLoadUserMusicState(
      LoadUserMusicState event, Emitter<MusicState> emit) async {
    if (_isInitialized) return; // Prevent multiple initializations
    
    emit(MusicLoading());
    _isInitialized = true;

    try {
      final response = await apiService.get('musics/getUserMusicState');
      if (kDebugMode) print(response);

      if (response["status"] != 200) {
        if (!_isInitialized) return; // Prevent state change if already reset
        emit(MusicNewAccount());
        return;
      }

      final currentMusicId = response['state']['currentMusicId'];
      final isPlaying = response['state']['isPlaying'];
      final position =
          Duration(seconds: (response['state']['currentTime'] ?? 0).toInt());
      print(position);

      // Không chờ mà lấy stream nhạc song song
      final streamFuture =
          apiService.getStream('musics/getStreamMusic/$currentMusicId');

      final streamAudio = await streamFuture;
      if (streamAudio?.statusCode != 200) {
        if (!_isInitialized) return; // Prevent state change if already reset
        emit(MusicNewAccount());
        return;
      }

      final infoTracks =
          await apiService.get('musics/getMusicInfo/$currentMusicId');

      if (infoTracks['status'] != 200) {
        if (!_isInitialized) return; // Prevent state change if already reset
        emit(MusicNewAccount());
        return;
      }

      final data = infoTracks['data'];
      final imgTracks = data['imgPath'];
      final nameTracks = data['name'];
      final artistTracks = data['artist'];
      final lyrics = _processLyrics(data['lyrics']);

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
      musicLoveBloc.add(CheckMusicLoveEvent(currentMusicId));
      
      if (!_isInitialized) return; // Prevent state change if already reset
      emit(MusicLoaded(
        name: nameTracks,
        artist: artistTracks,
        currentMusicId: currentMusicId,
        isPlaying: isPlaying,
        duration: duration,
        position: position,
        musicUrl: imgTracks,
        lyrics: lyrics,
      ));
      _audioPlayer.seek(position);
      add(UpdatePosition(position: position));
    } catch (e) {
      print("Error loading user music state: $e");
      if (!_isInitialized) return; // Prevent state change if already reset
      emit(MusicNewAccount());
    }
  }

  Future<void> _onPlayMusicOnFirst(
      PlayStreamMusic event, Emitter<MusicState> emit) async {
    try {
      // Stop current playback if any
      await _audioPlayer.stop();
      
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
        final lyrics = _processLyrics(data['lyrics']);
        musicLoveBloc.add(CheckMusicLoveEvent(event.musicId));
        emit(MusicLoaded(
          name: nameTracks,
          artist: artistTracks,
          currentMusicId: event.musicId,
          isPlaying: false,
          duration: _audioPlayer.duration ?? Duration.zero,
          position: Duration.zero,
          musicUrl: imgTracks,
          lyrics: lyrics,
        ));

        // Create a temporary file to store the stream
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_audio.mp3');
        
        // Kiểm tra và xóa file cũ nếu tồn tại
        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (e) {
            print('Không thể xóa file tạm: $e');
          }
        }
        
        // Write stream to file
        IOSink? sink;
        try {
          sink = tempFile.openWrite();
          await for (final chunk in response!.stream) {
            sink.add(chunk);
          }
          await sink.close();
          
          // Kiểm tra xem file đã được tạo thành công chưa
          if (!await tempFile.exists()) {
            throw Exception('Không thể tạo file tạm thời');
          }
          
          // Create audio source from file
          final audioSource = AudioSource.uri(
            Uri.file(tempFile.path),
            tag: MediaItem(
              id: event.musicId,
              album: nameTracks,
              title: nameTracks,
              artist: artistTracks,
              artUri: Uri.parse(imgTracks),
            ),
          );
          
          // Set audio source and play
          await _audioPlayer.setAudioSource(audioSource);
          await _audioPlayer.play();
          
          // Clean up temp file after playback
          _audioPlayer.playerStateStream.listen((state) {
            if (state.processingState == ProcessingState.completed) {
              try {
                if (tempFile.existsSync()) {
                  tempFile.deleteSync();
                }
              } catch (e) {
                print('Không thể xóa file sau khi phát xong: $e');
              }
            }
          });
          
        } catch (e) {
          // Đảm bảo sink được đóng
          await sink?.close();
          // Xóa file tạm nếu có lỗi
          try {
            if (tempFile.existsSync()) {
              tempFile.deleteSync();
            }
          } catch (e) {
            print('Không thể xóa file khi có lỗi: $e');
          }
          print("Error writing stream to file: $e");
        }
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
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        emit(MusicLoaded(
          currentMusicId: event.musicId,
          name: currentState.name,
          artist: currentState.artist,
          musicUrl: currentState.musicUrl,
          lyrics: currentState.lyrics,
          isPlaying: false,
          position: currentState.position,
          duration: currentState.duration,
        ));
      }
    } catch (e) {
      print("Lỗi khi tạm dừng nhạc: $e");
    }
  }

  Future<void> _playMusic(PlayMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.play();
      if (state is MusicLoaded) {
        final currentState = state as MusicLoaded;
        emit(MusicLoaded(
          currentMusicId: event.musicId,
          name: currentState.name,
          artist: currentState.artist,
          musicUrl: currentState.musicUrl,
          lyrics: currentState.lyrics,
          isPlaying: true,
          position: currentState.position,
          duration: currentState.duration,
        ));
      }
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
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
      if (!_isInitialized) return;
      
      // Cancel all subscriptions
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _playbackStateSubscription?.cancel();
      
      // Stop and dispose the current player
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      
      // Create a new AudioPlayer instance
      _audioPlayer = AudioPlayer();
      
      // Reset state
      _isInitialized = false;
      _previousState = null;
      _isNextCalled = false;
      playlist = [];
      
      // Set up new listeners
      _setupEventListeners();
      
      // Emit initial state
      emit(MusicInitial());
    } catch (e) {
      print("Lỗi khi logout: $e");
    }
  }
}
