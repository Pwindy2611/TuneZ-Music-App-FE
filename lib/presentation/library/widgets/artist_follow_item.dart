import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';

class ArtistFollowItem extends StatefulWidget {
  final String image;
  final String name;

  const ArtistFollowItem({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  _ArtistFollowItemState createState() => _ArtistFollowItemState();
}

class _ArtistFollowItemState extends State<ArtistFollowItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => setState(() => isTapped = true),
        onTapUp: (_) => setState(() => isTapped = false),
        onTapCancel: () => setState(() => isTapped = false),
        child:
            BlocBuilder<LibraryUIBloc, LibraryState>(builder: (context, state) {
          bool isListView = state.isGridView;
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedScale(
                  scale: isTapped ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: isListView
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildContent(isListView, widget),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _buildContent(isListView, widget),
                        )),
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isTapped ? 0.3 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(color: Colors.black),
                ),
              ),
            ],
          );
        }));
  }
}

List<Widget> _buildContent(
  bool isListView,
  dynamic widget,
) {
  return [
    Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(widget.image),
          fit: BoxFit.cover,
        ),
      ),
    ),
    const SizedBox(height: 10,width: 30,),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        widget.name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 5,),
      Text(
        'Nghệ sĩ',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
        textAlign: TextAlign.center,
      )
      ],
    )
  ];
}
