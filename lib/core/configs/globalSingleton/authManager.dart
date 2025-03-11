import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal(); // Constructor private

  bool isLoggedIn = false; // Mặc định chưa đăng nhập

  void login() {
    isLoggedIn = true;
  }

  bool canLogout() {
    return isLoggedIn;
  }

void logout(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    if (await googleSignIn.isSignedIn()) { // Kiểm tra nếu đã đăng nhập
      await googleSignIn.signOut();
    }

    await FirebaseAuth.instance.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
