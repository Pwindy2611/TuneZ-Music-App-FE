import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class StickyHeaderSearchDelegate extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  StickyHeaderSearchDelegate({required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey;

  @override
  double get maxExtent => 100.0;
  @override
  double get minExtent => 100.0;

  Future<String> _getUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userProfilePicture') ?? '';
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: FutureBuilder<String>(
                future: _getUserAvatar(),
                builder: (context, snapshot) {
                  String avatarUrl = snapshot.data ?? '';
                  return CircleAvatar(
                    radius: 24,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : AssetImage(AppImages.localAvt) as ImageProvider,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Tìm Kiếm",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
