import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ApiService _apiService;

  UploadBloc(this._apiService) : super(UploadInitial()) {
    on<UploadMusic>(_onUploadMusic);
  }

  Future<void> _onUploadMusic(
    UploadMusic event,
    Emitter<UploadState> emit,
  ) async {
    try {
      emit(UploadLoading());
      final prefs = await SharedPreferences.getInstance();
            final userId = prefs.getString('userId');
            if (userId == null) {
              emit(UploadError('User ID not found'));
              return;
            }
      // Create FormData with proper file handling
      final formData = FormData.fromMap({
        'name': event.name,
        'userId': userId,
        'artist': event.artist,
        'duration': event.duration,
        'genres': jsonEncode(event.genres),
        'musicFile': await MultipartFile.fromFile(
          event.musicFile.path,
          filename: event.musicFile.path.split('/').last,
        ),
        'imgFile': await MultipartFile.fromFile(
          event.imgFile.path,
          filename: event.imgFile.path.split('/').last,
        ),
      });

      final response = await _apiService.postFormData(
        formData,
        'musics/uploadMusicByUser',
      );

      if (response['status'] == 'success') {
        emit(UploadSuccess());
      } else {
        print('Error uploading music: ${response['message']}');
        emit(UploadError(response['message'] ?? 'Upload failed'));
      }
    } catch (e) {
      print('Error uploading music: $e');
      emit(UploadError(e.toString()));
    }
  }
}