import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_theme.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/data/services/firebase_options.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/recent_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/throwback_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter khởi tạo đúng
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

  runApp(
    MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => HomePlaylistBloc(ApiService())),
      BlocProvider(create: (context) => RecentPlaylistBloc(ApiService())),
      BlocProvider(create: (context) => ThrowbackPlaylistBloc(ApiService())),
      BlocProvider(create: (context) => LoginBloc(ApiService())),
      BlocProvider(create: (context) => ArtistSelectionBloc(ApiService())),
    ],
    child:MainApp())
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
 