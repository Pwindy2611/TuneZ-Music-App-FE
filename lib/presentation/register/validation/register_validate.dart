String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Đừng quên nhập email.';
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ.';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Nhập mật khẩu.';
  if (value.length < 8) return 'Mật khẩu phải ít nhất 8 ký tự.';
  if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất một chữ cái viết thường.';
  }
  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất một chữ cái viết hoa.';
  }
  if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất một chữ số.';
  }
  if (!RegExp(r'(?=.*[!@#\$&*~.,;:\-_=+^%])').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất một ký tự đặc biệt.';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) return 'Nhập tên của bạn.';
  return null;
}

String? validateOtp(String? value) {
  if (value == null || value.isEmpty) return 'Nhập mã OTP.';
  if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
    return 'OTP phải gồm 6 chữ số.';
  }
  return null;
}
