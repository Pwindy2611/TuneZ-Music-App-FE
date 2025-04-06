import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tunezmusic/presentation/splash/bloc/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkUserCache() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (isClosed) return;
      
      final bool userInCache = await _isUserInCache();
      if (isClosed) return;
      
      if (userInCache) {
        emit(UserInCache());
      } else {
        emit(UserNotInCache());
      }
    } catch (e) {
      if (!isClosed) {
        emit(UserNotInCache());
      }
    }
  }

  Future<bool> _isUserInCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }
}
