import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/presentation/upload/bloc/upload_bloc.dart';
import 'package:tunezmusic/presentation/upload/pages/upload_page.dart';

class StickyHeaderLibraryDelegate extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  StickyHeaderLibraryDelegate({required GlobalKey<ScaffoldState> scaffoldKey})
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
              "Thư viện",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UploadPage(),
                        ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            )
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
