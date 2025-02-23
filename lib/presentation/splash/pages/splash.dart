import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/presentation/intro/pages/get_started.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';
import 'package:tunezmusic/presentation/splash/bloc/splash_cubit.dart';
import 'package:tunezmusic/presentation/splash/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (_) => SplashCubit()..checkUserCache(), 
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UserInCache) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          } else if (state is UserNotInCache) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GetStartedPage()),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: SvgPicture.asset(
              AppVectors.logo,
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
