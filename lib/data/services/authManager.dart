import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_event.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart' show ArtistFollowBloc;
import 'package:tunezmusic/presentation/library/bloc/artist_follow_event.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_event.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_event.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  late final ApiService apiService; 
  AuthManager._internal(){
     apiService = ApiService();
  } // Constructor private

  bool isLoggedIn = false; // Mặc định chưa đăng nhập

  void login() {
    isLoggedIn = true;
  }

  bool canLogout() {
    return isLoggedIn;
  }

void logout(BuildContext context) async {
  try {
    final userPlaylistBloc = context.read<HomePlaylistBloc>();
    final artistFollowBloc = context.read<ArtistFollowBloc>();
    final musicBloc = context.read<MusicBloc>();
    final paymentBloc = context.read<SubscriptionsBloc>();
    final musicLoveList = context.read<MusicLoveListBloc>();
    
    // Add ResetStateEvent to reset the state of each Bloc
    userPlaylistBloc.add(ResetHomePlaylistStateEvent());
    artistFollowBloc.add(ResetArtistFollowStateEvent());
    musicBloc.add(ResetStateEvent());
    paymentBloc.add(ResetSubscriptionsState());
    musicLoveList.add(ResetMusicLoveListStateEvent());

    musicBloc.add(LogoutEvent());
    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    if (await googleSignIn.isSignedIn()) { // Kiểm tra nếu đã đăng nhập
      await googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await apiService.clearCookies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashPage()),
        );
      }
    });
  } catch (e) {
    print("Lỗi đăng xuất: $e");
  }
}
}
