import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_theme.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/data/services/firebase_options.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_bloc.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_bloc.dart';
import 'package:tunezmusic/presentation/history/bloc/history_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/recent_playlist_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_bloc.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load .env nếu cần

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

runApp(
  MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => HomePlaylistBloc(ApiService())),
      BlocProvider(create: (context) => RecentPlaylistBloc(ApiService())),
      BlocProvider(create: (context) => ArtistFollowBloc(ApiService())),
      BlocProvider(create: (context) => LoginBloc(ApiService())),
      BlocProvider(create: (context) => ArtistSelectionBloc(ApiService())),
      BlocProvider(create: (context) => LibraryUIBloc()),
      BlocProvider(create: (context) => NavigationBloc()),
      BlocProvider(
        create: (context) => MusicLoveListBloc(ApiService()),
      ),
      BlocProvider(
        create: (context) => MusicLoveBloc(
          ApiService(),
          context.read<MusicLoveListBloc>(),
        ),
      ),
      BlocProvider(
        create: (context) => MusicBloc(
          ApiService(),
          context.read<MusicLoveBloc>(),
        ),
      ),
      BlocProvider(create: (context) => HistoryBloc(ApiService())),
      BlocProvider(create: (context) => PaymentBloc(ApiService())),
      BlocProvider(create: (context) => SubscriptionsBloc(ApiService())),
      BlocProvider(create: (context) => ArtistTracksBloc(ApiService())),
    ],
    child: MainApp(),
  ),
);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
