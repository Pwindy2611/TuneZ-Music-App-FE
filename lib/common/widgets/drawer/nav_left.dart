import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/presentation/history/bloc/history_bloc.dart';
import 'package:tunezmusic/presentation/history/bloc/history_event.dart';
import 'package:tunezmusic/presentation/settingAccount/pages/setting_account.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_bloc.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_event.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('userName') ?? 'Người dùng',
      'email': prefs.getString('userEmail') ?? 'email@example.com',
      'avatar': prefs.getString('userProfilePicture') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      child: FutureBuilder<Map<String, String>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final userInfo = snapshot.data!;
          final avatarUrl = userInfo['avatar']!;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : AssetImage(AppImages.localAvt) as ImageProvider,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      userInfo['email']!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 134, 134, 134),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                          maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Color.fromARGB(255, 134, 134, 134)),
              ListTile(
                leading: const Icon(Icons.add_circle_outline_outlined, color: Colors.white),
                title: const Text(
                  "Thêm tài khoản",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.white),
                title: const Text(
                  "Bản phát hành mới",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<UserMusicBloc>().add(FetchUserMusic());
                  context.read<NavigationBloc>().add(OpenUserMusicEvent()); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text(
                  "Gần đây",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                   Navigator.pop(context);
                    context.read<HistoryBloc>().add(FetchHistoryEvent());
                    context.read<NavigationBloc>().add(OpenHistoryEvent()); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  "Cài đặt và quyền riêng tư",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SettingAccountPage()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
