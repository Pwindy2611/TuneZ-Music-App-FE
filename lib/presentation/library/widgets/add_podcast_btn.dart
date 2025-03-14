import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';

class AddPodcastWidget extends StatefulWidget {
  const AddPodcastWidget({
    super.key,
  });

  @override
  _AddPodcastWidgetState createState() => _AddPodcastWidgetState();
}

class _AddPodcastWidgetState extends State<AddPodcastWidget> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryUIBloc, LibraryState>(builder: (context, state) {
      bool isListView = state.isGridView; // Kiểm tra trạng thái
      return GestureDetector(
        onTapDown: (_) => setState(() => isTapped = true),
        onTapUp: (_) => setState(() => isTapped = false),
        onTapCancel: () => setState(() => isTapped = false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScale(
              scale: isTapped ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: isListView
                    ? SizedBox(
                        width: 100, // Thay đổi giá trị này theo ý muốn
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildContent(isListView),
                        ),
                      )
                    : Row(
                        // Chế độ lưới
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildContent(isListView),
                      ),
              ),
            ),

            // Overlay khi nhấn vào
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: isTapped ? 0.3 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Màu overlay
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

List<Widget> _buildContent(bool isListView) {
  return [
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: AppColors.darkGrey),
      width: isListView ? null : 70,
        height: isListView ? 95 : 70,
      child: Icon(
        Icons.add,
        color: AppColors.grey,
        size: 40,
      ),
    ),
    SizedBox(width: 20, height: 10),
    Text("Thêm Podcast",
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.left,
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.ellipsis),
  ];
}
