import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_playlistDetails.dart';
import 'package:tunezmusic/common/widgets/button/playlist_Detail_button.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/history/widgets/history_item.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_state.dart';

class PlayListLovePage extends StatefulWidget {
  const PlayListLovePage({super.key});

  @override
  _PlayListLovePageState createState() => _PlayListLovePageState();
}

class _PlayListLovePageState extends State<PlayListLovePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Bỏ focus khi nhấn ra ngoài
      },
      child: Stack(
        children: [
          Scaffold(
            body: BlocBuilder<MusicLoveListBloc, MusicLoveListState>(
              builder: (context, state) {
                if (state is MusicLoveListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MusicLoveListLoaded) {
                  return Container(
                      padding: const EdgeInsets.only(top: 80),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              child: Align(
                                alignment: Alignment.centerLeft, // Align text to the left
                                child: Text(
                                  "Bài hát đã thích",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height:
                                          40, // Chiều cao nhỏ hơn bình thường
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                14), // Font nhỏ hơn để phù hợp với height
                                        cursorColor: AppColors.primary,
                                        decoration: InputDecoration(
                                          hintText: "Tìm trong danh sách phát",
                                          hintStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                14, // Giảm kích thước chữ để phù hợp
                                          ),
                                          prefixIcon: const Icon(Icons.search,
                                              color: Colors.white, size: 28),
                                          prefixIconConstraints:
                                              const BoxConstraints(
                                            minWidth:
                                                40, // Giúp icon sát chữ hơn
                                          ),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              67, 255, 255, 255),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 3, horizontal: 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  PlaylistAppButton(
                                    onPressed: () {},
                                    title: "Sắp xếp",
                                    colors: Colors.white,
                                    textSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(
                                state.musicList.length,
                                (index) {
                                  final track = state.musicList[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: HistoryItemWidget(
                                      tracks: track,
                                      prColor: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ));
                } else if (state is MusicLoveListError) {
                  return Center(
                    child: Text(
                      "Không có lưu trữ gần đây",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return DotsLoading();
              },
            ),
          ),
          PlayListAppBar(
            title: "",
            blurAmount: 0,
            onBackPressed: () {
              context.read<NavigationBloc>().add(BackToLiEvent());
            },
          ),
        ],
      ),
    );
  }
}
