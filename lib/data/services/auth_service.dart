class AuthService {
  Future<bool> sendOtp(String email) async {
    // Gửi mã OTP đến email
    await Future.delayed(Duration(seconds: 2)); // Giả lập thời gian gửi
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    return otp == '111111'; // Giả lập kiểm tra OTP
  }

  Future<bool> registerUser(String email, String password, String username) async {
    // Xử lý đăng ký người dùng
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
