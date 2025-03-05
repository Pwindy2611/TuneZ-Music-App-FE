import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_title.dart';
import 'package:tunezmusic/common/widgets/button/light_button.dart';
import 'package:tunezmusic/core/configs/globalSingleton/authManager.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';
import 'package:tunezmusic/presentation/splash/pages/splash.dart';

class SettingAccountPage extends StatelessWidget {
  SettingAccountPage({super.key});
  final AuthManager auth= AuthManager();

 Future<void> _signOut(BuildContext context) async {
  try {
    if(auth.canLogout()==true){
      auth.logout(context);
    }
  } catch (e) {
    print("Lỗi đăng xuất: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
          title: "Cài đặt",
          titleColor: Colors.white,
          titleSize: 18,
          bgColor: AppColors.darkGrey,
          onBackPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Tài khoản miễn phí",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  LightAppButton(
                    onPressed: () {},
                    title: "Dùng Premium",
                    height: 52,
                    textSize: 12,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  settingItem(Icons.account_circle_outlined, "Tài khoản",
                      "Tên người dùng"),
                  settingItem(Icons.music_note_outlined, "Nội dung & hiển thị",
                      "Canvas: Cho phép nội dung phản cảm"),
                  settingItem(Icons.volume_up, "Phát lại",
                      "Phát liên tục: tự động phát"),
                  settingItem(Icons.lock, "Quyền riêng tư & xã hội",
                      "Nghệ sĩ đã nghe gần đây"),
                  settingItem(Icons.notifications_active_outlined, "Thông báo",
                      "Thông báo đẩy: Email"),
                  settingItem(Icons.important_devices_outlined,
                      "Ứng dụng & thiết bị", "Google Maps: TuneZ Connect"),
                  settingItem(Icons.save_alt_sharp, "Tiết kiệm dữ liệu",
                      "Tải xuống qua dữ liệu di động"),
                  settingItem(Icons.bar_chart_rounded,
                      "Chất lượng & nội dung nghe", "Wi-Fi & dữ liệu di động"),
                  settingItem(Icons.recommend_sharp, "Quảng cáo",
                      "Quảng cáo được cá nhân hoá"),
                  settingItem(Icons.insert_comment_rounded, "Giới thiệu",
                      "Phiên bản: Chính sách quyền riêng tư"),
                  const SizedBox(height: 20),
                  LightAppButton(
                    onPressed: () => _signOut(context),
                    title: "Đăng xuất",
                    height: 52,
                    textSize: 12,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
