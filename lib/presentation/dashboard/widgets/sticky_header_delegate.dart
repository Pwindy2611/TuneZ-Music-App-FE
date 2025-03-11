import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/common/widgets/button/cate_home_button.dart';

class StickyDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ValueNotifier<int> _selectedIndexNotifier;

  StickyDashboardHeaderDelegate({required GlobalKey<ScaffoldState> scaffoldKey, required ValueNotifier<int> selectedIndexNotifier})
      : _scaffoldKey = scaffoldKey,
        _selectedIndexNotifier = selectedIndexNotifier;

  @override
  double get maxExtent => 100.0;
  @override
  double get minExtent => 95.0;

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
              child: const CircleAvatar(
                backgroundImage: AssetImage(AppImages.localAvt),
              ),
            ),
            const SizedBox(width: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Sử dụng ValueListenableBuilder để theo dõi sự thay đổi của selectedIndexNotifier
                ValueListenableBuilder<int>(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selectedIndex, child) {
                    return _buildCategoryButton(0, 'Tất cả', selectedIndex == 0);
                  },
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder<int>(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selectedIndex, child) {
                    return _buildCategoryButton(1, 'Nhạc', selectedIndex == 1);
                  },
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder<int>(
                  valueListenable: _selectedIndexNotifier,
                  builder: (context, selectedIndex, child) {
                    return _buildCategoryButton(2, 'Podcasts', selectedIndex == 2);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(int index, String label, bool isSelected) {
    return CateHomeButton(
      label: label,
      isSelected: isSelected,
      onPressed: () {
        _selectedIndexNotifier.value = index; // Cập nhật index được chọn
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

