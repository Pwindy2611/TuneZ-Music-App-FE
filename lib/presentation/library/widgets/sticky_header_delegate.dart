import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class StickyHeaderLibraryhDelegate extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  StickyHeaderLibraryhDelegate({required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey;

  @override
  double get maxExtent => 100.0;
  @override
  double get minExtent => 100.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomLeft,
        child:  Row(
        children: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage(AppImages.localAvt),
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
          SizedBox(width: 15,),
           const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
            ],
          )
        ],
      ),
      )
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
