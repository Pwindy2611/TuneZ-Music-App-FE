import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 50),
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(AppImages.localAvt),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pwindycutedthwdepzainhathemattroi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Giới hạn chỉ hiển thị 1 dòng
                  overflow: TextOverflow
                      .ellipsis, // Thêm ba dấu chấm khi văn bản dài quá
                ),
                Text(
                  "Xem hồ sơ",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 134, 134, 134),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
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
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.history, color: Colors.white),
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
