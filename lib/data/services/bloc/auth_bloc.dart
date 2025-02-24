import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/lib/decode_token.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(AuthFailure("Người dùng đã hủy đăng nhập"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
     
      final res = await apiService.post(
        'users/login',
        {'idToken': googleAuth.accessToken},
      );
      if (kDebugMode) {
        print("API Res: ${res}");
         print("API Response: ${jsonEncode(res)}");
      }
      if (res['success'] == true) {
        String firebaseToken = res['firebaseToken'] ?? '';

        // Giải mã JWT để lấy userId
        String userId = extractUserIdFromToken(firebaseToken);

        // Lưu vào SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', firebaseToken);
        await prefs.setString('userId', userId);
      emit(AuthSuccess(userCredential.user!));
      }
    } catch (error) {
      emit(AuthFailure(error.toString()));
    }
  }
}
