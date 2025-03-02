import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tunezmusic/core/lib/decode_token.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';
import 'package:tunezmusic/presentation/login/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc(this.apiService) : super(LoginInitialState()) {
    on<LoginEmailEvent>(_onLoginByEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithFacebookEvent>(_onSignInWithFacebook);
  }

  // Xử lý sự kiện đăng nhập email
  Future<void> _onLoginByEmail(
    LoginEmailEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginEmailLoadingState());
    try {
      // Đăng nhập Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user == null) {
        emit(
          LoginErrorState(
            "Đăng nhập không thành công, tài khoản không tồn tại.",
          ),
        );
        return;
      }

      // Lấy Firebase ID Token
      String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        emit(LoginErrorState("Không thể lấy ID Token từ Firebase."));
        return;
      }

      // Gọi hàm xử lý đăng nhập Firebase
      await handleLoginResponseByServer(idToken, emit, (errorMessage) {
        LoginErrorState((errorMessage));
      });
    } catch (e) {
      emit(LoginErrorState("Lỗi khi đăng nhập: ${e.toString()}"));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginGoogleLoadingState());

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(LoginGoogleErrorState("Người dùng đã hủy đăng nhập"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      String idToken = await userCredential.user?.getIdToken() ?? '';
      await handleLoginResponseByServer(idToken, emit, (errorMessage) {
        LoginGoogleErrorState((errorMessage));
      });
    } catch (error) {
      emit(LoginGoogleErrorState(error.toString()));
    }
  }

  Future<void> _onSignInWithFacebook(
    SignInWithFacebookEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginFacebookLoadingState());

      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;
        if (accessToken != null) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          try {
            final UserCredential userCredential =
                await _auth.signInWithCredential(facebookAuthCredential);
            String idToken = await userCredential.user?.getIdToken() ?? '';
            await handleLoginResponseByServer(idToken, emit, (errorMessage) {
              LoginFacebookErrorState((errorMessage));
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'account-exists-with-different-credential') {
              await _handleDifferentCredentialCase(e, emit);
            } else {
              emit(LoginFacebookErrorState("Lỗi FirebaseAuth: ${e.message}"));
            }
          }
        } else {
          emit(LoginFacebookErrorState(
              "Không lấy được AccessToken từ Facebook"));
        }
      }
    } catch (error) {
      emit(LoginFacebookErrorState(
          "Lỗi đăng nhập Facebook: ${error.toString()}"));
    }
  }

  Future<void> _handleDifferentCredentialCase(
    FirebaseAuthException e,
    Emitter<LoginState> emit,
  ) async {
    if (kDebugMode) {
      print("dasdsadsa");
    }
    AuthCredential? credential = e.credential;
    String email = e.email.toString();
    if (kDebugMode) {
      print(email);
    }
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print("Credential: $credential");
      print("Current User: $currentUser");
    }

    if (currentUser == null) {
      try {
        final res =
            await apiService.get("users/getUserCustomToken?email=$email");
        if (kDebugMode) {
          print(res);
        }
        if (res['status'] == 200) {
          if (res.containsKey('token') && res['token'] != null) {
            String token = res['token']; // Truy cập trực tiếp `token`

            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCustomToken(token);
            User? currentUser = userCredential.user;

            if (currentUser != null) {
              if (kDebugMode) {
                print("Đăng nhập bằng token thành công!");
              }
              await currentUser.linkWithCredential(credential!);
              String idToken = await currentUser.getIdToken() ?? '';
              await handleLoginResponseByServer(idToken, emit, (errorMessage) {
                emit(LoginFacebookErrorState(errorMessage));
              });
            }
          } else {
            emit(LoginFacebookErrorState(
                "Lỗi: Không tìm thấy token trong phản hồi API"));
          }
        } else {
          emit(LoginFacebookErrorState(
              "Lỗi: API trả về trạng thái ${res['status']}"));
        }
      } catch (error) {
        emit(LoginFacebookErrorState(
            "Lỗi liên kết tài khoản: ${error.toString()}"));
      }
    } else {
      emit(LoginFacebookErrorState("Không có người dùng nào đang đăng nhập."));
    }
  }

  // Xử lý phản hồi từ server sau khi gửi ID Token Firebase
  Future<void> handleLoginResponseByServer(
    String idToken,
    Emitter<LoginState> emit,
    Function(String) onError, // Thêm callback xử lý lỗi
  ) async {
    try {
      if (kDebugMode) {
        print(idToken);
      }
      final res = await apiService.post('users/login', {'idToken': idToken});

      if (kDebugMode) {
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

        emit(LoginCompletedState());
      } else {
        if (res['message'] == "Email not verified") {
          emit(DoVerifiedLoginState());
          return;
        }
        onError("Lỗi: ${res['message']}"); // Gọi callback để xử lý lỗi
      }
    } catch (e) {
      // Kiểm tra xem e có chứa JSON không
      if (e is FormatException) {
        onError("Lỗi định dạng phản hồi từ server: ${e.message}");
      } else if (e.toString().contains("Email not verified")) {
        emit(DoVerifiedLoginState());
      } else {
        onError("Lỗi khi xử lý phản hồi từ server: ${e.toString()}");
      }
    }
  }
}
