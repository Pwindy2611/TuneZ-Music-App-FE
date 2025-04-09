import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_bloc.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_event.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_bloc.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_event.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_event.dart';
import 'package:tunezmusic/presentation/history/bloc/history_bloc.dart';
import 'package:tunezmusic/presentation/history/bloc/history_event.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart' show ArtistFollowBloc;
import 'package:tunezmusic/presentation/library/bloc/artist_follow_event.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_event.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';
import 'package:tunezmusic/presentation/main/bloc/recent_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/recent_playlist_event.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_bloc.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_event.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_event.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_event.dart';
import 'package:tunezmusic/presentation/search/bloc/search_bloc.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_bloc.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_event.dart';

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
    final recentPlaylistBloc = context.read<RecentPlaylistBloc>();
    final loginBloc = context.read<LoginBloc>();
    final artistSelectionBloc = context.read<ArtistSelectionBloc>();
    final navigationBloc = context.read<NavigationBloc>();
    final musicLoveBloc = context.read<MusicLoveBloc>();
    final historyBloc = context.read<HistoryBloc>();
    final paymentsBloc = context.read<PaymentBloc>();
    final artistTracksBloc = context.read<ArtistTracksBloc>();
    final searchBloc = context.read<SearchBloc>();
    final userMusic = context.read<UserMusicBloc>();
    
    // Add ResetStateEvent to reset the state of each Bloc
    userPlaylistBloc.add(ResetHomePlaylistStateEvent());
    userMusic.add(ResetUserMusicState());
    artistFollowBloc.add(ResetArtistFollowStateEvent());
    paymentBloc.add(ResetSubscriptionsState());
    musicLoveList.add(ResetMusicLoveListStateEvent());
    recentPlaylistBloc.add(ResetRecentPlaylistStateEvent());
    loginBloc.add(ResetLoginStateEvent());
    artistSelectionBloc.add(ResetArtistSelectionStateEvent());
    navigationBloc.add(ResetNavigationStateEvent());
    musicLoveBloc.add(ResetMusicLoveStateEvent());
    historyBloc.add(ResetHistoryStateEvent());
    paymentsBloc.add(ResetPaymentStateEvent());
    artistTracksBloc.add(ResetArtistTracksStateEvent());
    searchBloc.add(ResetSearchStateEvent());
    musicBloc.add(LogoutEvent());
    
    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    if (await googleSignIn.isSignedIn()) {
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
