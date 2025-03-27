import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_playlistDetails.dart';
import 'package:tunezmusic/common/widgets/button/playlist_Detail_button.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_bloc.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_event.dart';
import 'package:tunezmusic/presentation/artistDetails/bloc/artist_tracks_state.dart';
import 'package:tunezmusic/presentation/playlistDetail/widgets/item_track.dart';

class ArtistPlayListDetail extends StatefulWidget {
  final String imgURL;
  final String nameArtist;

  const ArtistPlayListDetail(
      {super.key, required this.imgURL, required this.nameArtist});

  @override
  State<ArtistPlayListDetail> createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<ArtistPlayListDetail> {
  late ScrollController _scrollController;
  final double targetY = 50; // Vị trí bắt đầu làm mờ
  double _blurAmount = 0; // Độ mờ mặc định
  Color _dominantColor = AppColors.grey; // Màu chủ đạo ban đầu
  bool _isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _onScroll();
        });
      });
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _extractDominantColor();
    await Future.microtask(() => 
      context.read<ArtistTracksBloc>().add(FetchArtistTracks(artistName: widget.nameArtist))
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    _updateBlurEffect();
  }

  void _updateBlurEffect() {
    double offset = _scrollController.offset;
    double newBlur = (offset > targetY)
        ? ((offset - targetY) / (300 - targetY) * 20).clamp(0, 20)
        : 0;

    if ((_blurAmount - newBlur).abs() > 0.5) {
      setState(() => _blurAmount = newBlur);
    }
  }

  Future<void> _extractDominantColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(widget.imgURL));

    final newColor = paletteGenerator.dominantColor?.color ?? AppColors.grey;
    if (newColor != _dominantColor && mounted) {
      setState(() {
        _dominantColor = newColor;
      });
    }
  }

  double _getOpacity() {
    if (!_scrollController.hasClients) return 0.0;
    double scrollOffset = _scrollController.position.pixels;
    return (scrollOffset / 100).clamp(0.0, 1);
  }

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return "$hours giờ $minutes phút";
    } else {
      return "$minutes phút";
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? DotsLoading()
          : NotificationListener<ScrollUpdateNotification>(
              onNotification: (ScrollUpdateNotification notification) {
                setState(() {
                  // Force rebuild on scroll
                });
                return true;
              },
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        widget.imgURL,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.bottomLeft,
                          height: 270,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _dominantColor.withOpacity(_getOpacity()),
                                _dominantColor.withOpacity(_getOpacity() * 1),
                              ],
                            ),
                          ),
                          child: Text(
                            widget.nameArtist,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _dominantColor,
                                AppColors.darkBackground,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.nameArtist,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.normal)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "760,5 N Người nghe hàng tháng",
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors
                                                    .grey, // Màu viền
                                                width: 2, // Độ dày viền
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Bo tròn viền để khớp với ClipRRect
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.network(
                                                widget.imgURL,
                                                width: 25,
                                                height: 35,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.white), // Viền trắng
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8), // Bo tròn
                                              ),
                                              minimumSize: Size.zero,
                                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8), // Khoảng cách giữa viền và chữ
                                            ),
                                            onPressed: () {
                                              // Xử lý khi nhấn nút
                                            },
                                            child: const Text(
                                              "Đang theo dõi",
                                              style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold), // Chữ màu trắng
                                            ),
                                          ),
                                           SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.more_vert_outlined,
                                                size: 28,
                                              ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: SvgPicture.asset(
                                              AppVectors.shuffleIcon,
                                              color: _dominantColor,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          // BlocBuilder<MusicBloc,
                                          //         MusicState>(
                                          //     builder: (context, state) {
                                          //   if (state is MusicLoaded) {
                                          //     final currentTrack = widget
                                          //         .playlist['tracks']
                                          //         .firstWhere(
                                          //       (track) =>
                                          //           track['_id'] ==
                                          //           state.currentMusicId,
                                          //       orElse: () => null,
                                          //     );

                                          //     if (currentTrack != null) {
                                          //       return IconButton(
                                          //         onPressed: () {
                                          //           context
                                          //               .read<MusicBloc>()
                                          //               .add(
                                          //                 state.isPlaying
                                          //                     ? PauseMusic(
                                          //                         musicId: state
                                          //                             .currentMusicId)
                                          //                     : PlayMusic(
                                          //                         musicId: state
                                          //                             .currentMusicId),
                                          //               );
                                          //         },
                                          //         icon: Icon(
                                          //           state.isPlaying
                                          //               ? Icons
                                          //                   .pause_circle_filled_rounded
                                          //               : Icons
                                          //                   .play_circle_fill_rounded,
                                          //           color: _dominantColor,
                                          //           size: 60,
                                          //         ),
                                          //       );
                                          //     }
                                          //   }
                                          //   return IconButton(
                                          //     onPressed: () {
                                          //       context
                                          //           .read<MusicBloc>()
                                          //           .add(UpdatePlaylist(
                                          //               allTracks:
                                          //                   widget.playlist['tracks'].map((t) => t['_id'].toString()).toList()));
                                          //       context
                                          //           .read<MusicBloc>()
                                          //           .add(
                                          //               RanDomTrackEvent());
                                          //     },
                                          //     icon: Icon(
                                          //       Icons
                                          //           .play_circle_fill_rounded,
                                          //       color: _dominantColor,
                                          //       size: 60,
                                          //     ),
                                          //   );
                                          // })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //TRACKS PLAYLIST
                        BlocBuilder<ArtistTracksBloc, ArtistTracksState>(
                          builder: (context, state) {
                            if (state is ArtistTracksLoaded) {
                              return Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: AppColors.darkBackground),
                                child: Column(
                                  children: state.tracks.map<Widget>((track) {
                                    return TrackItemWidget(
                                      track: track,
                                      prColor: _dominantColor,
                                      allTracks: state.tracks
                                          .map((t) => t['_id'].toString())
                                          .toList(),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                            return Container(); // Return empty container if state is not loaded
                          },
                        ),
                      ],
                    ),
                  ),
                  PlayListAppBar(
                    title: widget.nameArtist,
                    blurAmount: _blurAmount,
                    onBackPressed: () {
                      context.read<NavigationBloc>().add(BackToLiEvent());
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
