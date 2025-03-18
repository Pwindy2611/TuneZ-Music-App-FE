import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_theme.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/data/services/firebase_options.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/recent_playlist_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => HomePlaylistBloc(ApiService())),
    BlocProvider(create: (context) => RecentPlaylistBloc(ApiService())),
    BlocProvider(create: (context) => ArtistFollowBloc(ApiService())),
    BlocProvider(create: (context) => LoginBloc(ApiService())), 
    BlocProvider(create: (context) => ArtistSelectionBloc(ApiService())),
    BlocProvider(create: (context) => LibraryUIBloc()),
    BlocProvider(create: (context) => NavigationBloc()),  
    BlocProvider(create: (context) => MusicBloc(ApiService())),
  ], child: MainApp()));
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
