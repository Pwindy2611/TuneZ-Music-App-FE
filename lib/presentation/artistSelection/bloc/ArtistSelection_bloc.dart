import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/data/services/authManager.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_event.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_state.dart';
import 'package:tunezmusic/presentation/login/bloc/login_state.dart';

class ArtistSelectionBloc
    extends Bloc<ArtistSelectionEvent, ArtistSelectionState> {
  final AuthManager auth = AuthManager();
  final ApiService apiService;
  ArtistSelectionBloc(this.apiService) : super(ArtistSelectionLoadingState()) {
    on<ArtistSelectionPostEvent>(handleArtistSelectionPostEvent);
    on<ArtistSelectionFetchEvent>(handleArtistSelectionFetchEvent);
    on<ResetArtistSelectionStateEvent>(_onResetState);
  }

  Future<void> handleArtistSelectionPostEvent(ArtistSelectionPostEvent event,
      Emitter<ArtistSelectionState> emit) async {
    emit(ArtistSelectionPostLoadingState());
    if (kDebugMode) {
      print(event.selectedArtists);
    }
    final pref = await SharedPreferences.getInstance();
    final savedUserId = pref.getString('userId');
    if (savedUserId != null && savedUserId.isNotEmpty) {
      if (kDebugMode) {
        print(event.selectedArtists);
      }
      try {
        final res = await apiService.post("follow/addFollowing", {
          "followingIds": event.selectedArtists,
          "followType": "officialArtist"
        });
        if (kDebugMode) {
          print(res);
        }
        if (res["status"] == 201) {
          emit(ArtistSelectionFetchPostState());

            final userInfo = await apiService.get('users/getUserInfo');
          if (kDebugMode) {
            print('Thông tin user: $userInfo');
          }

          // Kiểm tra response hợp lệ
          if (userInfo['status'] == 200 && userInfo['user'] != null) {
            final user = userInfo['user'];
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userId', user['id'] ?? '');
            await prefs.setString('userName', user['name'] ?? '');
            await prefs.setString('userEmail', user['email'] ?? '');
            await prefs.setString(
                'userProfilePicture', user['profilePicture'] ?? '');
          }

          auth.login();
        } else {
          emit(ArtistSelectionPostErrorState("Failed to follow artists"));
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error following artists: $e");
        }
        emit(ArtistSelectionPostErrorState(e.toString()));
      }
    }
  }

  Future<void> handleArtistSelectionFetchEvent(ArtistSelectionFetchEvent event,
      Emitter<ArtistSelectionState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      if (savedUserId != null) {
        final response = await apiService.get("offartist/getAllOfficialArtist");
        if (kDebugMode) {
          print(response.toString());
        }
        if (response != null && response.containsKey("artists")) {
          final artistsData = response["artists"];

          if (artistsData is List<dynamic>) {
            final List<Map<String, dynamic>> allArtists =
                artistsData.map((artist) {
              return {
                "id": artist["key"],
                "name": artist["name"],
                "img": artist["profile"]?["profileImage"],
              };
            }).toList();

            emit(ArtistSelectionFetchSuccessState(allArtists));
          } else {
            emit(ArtistSelectionFetchErrorState(
                "Invalid data format for artists"));
          }
        } else {
          emit(ArtistSelectionFetchErrorState(
              "Invalid data format for artists"));
        }
      } else {
        emit(ArtistSelectionFetchErrorState("Invalid response from server"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching artists: $e");
      }
      emit(ArtistSelectionFetchErrorState(e.toString()));
    }
  }

  void _onResetState(ResetArtistSelectionStateEvent event, Emitter<ArtistSelectionState> emit) {
    emit(ArtistSelectionInitial());
  }
}