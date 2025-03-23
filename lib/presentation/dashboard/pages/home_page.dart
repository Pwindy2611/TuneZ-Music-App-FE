// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/artistAndPodcastersColumn.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_state.dart';
import 'package:tunezmusic/presentation/playlistDetail/pages/playlistDetail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  var isDeviceConnected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          //physics: ScrollPhysics(),
          primary: true,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<HomePlaylistBloc, HomePlaylistState>(
                  builder: (context, state) {
                    if (state is HomePlaylistLoaded) {
                      List playlistsData = state.playlist;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: playlistsData.map((playlistGroup) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hiển thị tên category
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 15, right: 15, bottom: 15),
                                child: Text(
                                  playlistGroup[
                                      "category"], // Lấy tên category từ API
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontFamily: "SpotifyCircularBold",
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              // Hiển thị danh sách playlist
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        (playlistGroup["playlists"] as List)
                                            .map((playlist) {
                                      return ArtistAndPodcastersColumn(
                                        callback: () {
                                          context.read<NavigationBloc>().add(OpenPlaylistDetailEvent(playlist));
                                        },
                                        name: playlist["title"], // Tên playlist
                                        image: playlist[
                                            "coverImage"], // Ảnh playlist
                                        borderRadius: 4,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    } else if (state is HomePlaylistError) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  },
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: SizedBox(height: 140, width: double.infinity))
              ]),
    );
  }

//   showDialogBox() {
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               title: const Text(
//                 "No internet connection",
//                 style: TextStyle(
//                     fontFamily: "SpotifyCircularBold", color: Colors.white),
//               ),
//               content: const Text(
//                 "Turn on mobile data or connect to Wi-Fi.",
//                 style: TextStyle(
//                     fontFamily: "SpotifyCircularLight",
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25)),
//               backgroundColor: AppColors.darkBackground,
//               actionsAlignment: MainAxisAlignment.center,
//               surfaceTintColor: Colors.red,
//               actions: <Widget>[
//                 ElevatedButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                         elevation: 10,
//                         textStyle: const TextStyle(
//                             fontFamily: "SpotifyCircularBold",
//                             color: Colors.white,
//                             fontSize: 18),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25)),
//                         fixedSize: const Size(250, 50)),
//                     child: const Text("Try Again"))
//               ],
//             ));
//   }
}
