import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_event.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';

class StickyHeaderFilterDelegate extends SliverPersistentHeaderDelegate {
  final ValueNotifier<bool> selectedIndexNotifier;

  StickyHeaderFilterDelegate({required this.selectedIndexNotifier});

  @override
  double get maxExtent => 30.0;

  @override
  double get minExtent => 30.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows_outlined),
                const SizedBox(width: 8),
                const Text(
                  'Gần đây',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const Spacer(),
            BlocBuilder<LibraryUIBloc, LibraryState>(
              builder: (context, state) {
                return GestureDetector(
                  child: IconButton(
                    icon: Icon(
                      state.isGridView ? Icons.list : Icons.now_widgets_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<LibraryUIBloc>().toggleViewMode();
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(), 
                    visualDensity:
                        VisualDensity.compact, 
                    splashColor: Colors.transparent,
                    highlightColor:
                        Colors.transparent, 
                  ),
                );
              },
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
