import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';

class SaveLovePlaylistWidget extends StatefulWidget {
  const SaveLovePlaylistWidget({
    super.key,
  });

  @override
  _SaveLovePlaylistWidgetState createState() => _SaveLovePlaylistWidgetState();
}

class _SaveLovePlaylistWidgetState extends State<SaveLovePlaylistWidget> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isTapped = true),
      onTapUp: (_) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      onTap: () {
        context.read<NavigationBloc>().add(OpenLovePLaylistEvent());
      },
      child: BlocBuilder<LibraryUIBloc, LibraryState>(
        builder: (context, state) {
          bool isListView = state.isGridView;

          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedScale(
                scale: isTapped ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: isListView
                      ? SizedBox(
                          width: 100, // Thay đổi giá trị này theo ý muốn
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildContent(bool isListView) {
    return [
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: isListView ? null : 70,
        height: isListView ? 95 : 70,
        child: Icon(
          Icons.heart_broken,
          color: Colors.white,
          size: isListView ? 40 : 30,
        ),
      ),
      SizedBox(width: 20, height: 10), // Điều chỉnh khoảng cách phù hợp
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yêu thích",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Danh sách phát nhạc yêu thích của bạn",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.deFautLabelIcon,
            ),
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ];
  }
}
