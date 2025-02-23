import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tunezmusic/presentation/splash/bloc/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUserCache() async {
    await Future.delayed(const Duration(seconds: 3));
    final bool userInCache = await _isUserInCache();
    if (userInCache) {
      emit(UserInCache());
    } else {
      emit(UserNotInCache());
    }
  }

  Future<bool> _isUserInCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }
}
