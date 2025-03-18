import 'package:flutter/material.dart';
import 'package:tunezmusic/common/widgets/button/cate_home_button.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class StickyHeaderOptionNavDelegate extends SliverPersistentHeaderDelegate {
  final ValueNotifier<int> selectedIndexNotifier;

  StickyHeaderOptionNavDelegate({required this.selectedIndexNotifier});

  @override
  double get maxExtent => 60.0;
  @override
  double get minExtent => 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ValueListenableBuilder<int>(
          valueListenable: selectedIndexNotifier,
          builder: (context, selectedIndex, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Hiệu ứng ẩn/hiện nút Close + đẩy button sang phải
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: selectedIndex > 0
                      ? ElevatedButton(
                          key: ValueKey(selectedIndex),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(55, 255, 255, 255),
                            elevation: 0,
                            shape: const CircleBorder(),
                            splashFactory: NoSplash.splashFactory,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(30, 30),
                            maximumSize: const Size(30, 30),
                          ),
                          onPressed: () {
                            selectedIndexNotifier.value = 0;
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Khoảng cách thay đổi mượt mà khi nút Close xuất hiện
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: selectedIndex > 0 ? 5 : 0,
                ),

                // Danh sách phát
                _buildSlidingButton(
                  isVisible: selectedIndex == 0 || selectedIndex == 1,
                  slideFromLeft: false,
                  isMainButton: selectedIndex == 1,
                  child: _buildCategoryButton(
                      1, 'Danh sách phát', selectedIndex == 1),
                ),

                if (selectedIndex == 0)
                  SizedBox(
                    width: 10,
                  ),

                // Podcast
                _buildSlidingButton(
                  isVisible: selectedIndex == 0 || selectedIndex == 2,
                  slideFromLeft: false,
                  isMainButton: selectedIndex == 2,
                  child: _buildCategoryButton(2, 'Podcast', selectedIndex == 2),
                ),

                if (selectedIndex == 0)
                  SizedBox(
                    width: 10,
                  ),

                // Podcast
                _buildSlidingButton(
                  isVisible: selectedIndex == 0 || selectedIndex == 3,
                  slideFromLeft: false,
                  isMainButton: selectedIndex == 3,
                  child: _buildCategoryButton(3, 'Nghệ sĩ', selectedIndex == 3),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Widget tạo hiệu ứng trượt mượt mà cho button
  Widget _buildSlidingButton({
  required bool isVisible,
  required bool slideFromLeft,
  required Widget child,
  required bool isMainButton,
}) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: isVisible
        ? TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(
              begin: isMainButton ? 0 : (slideFromLeft ? -50 : 50),
              end: 0,
            ),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isVisible ? 1.0 : 0.0,
                  child: child,
                ),
              );
            },
            child: child,
          )
        : const SizedBox.shrink(),
  );
}

  Widget _buildCategoryButton(int index, String label, bool isSelected) {
    return CateHomeButton(
      label: label,
      isSelected: isSelected,
      onPressed: () {
        selectedIndexNotifier.value = index;
      },
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
