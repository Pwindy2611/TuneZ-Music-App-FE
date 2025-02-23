// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/artistAndPodcastersColumn.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/recentPlaylistContainer.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/recentlyPlayed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_state.dart';

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
    return Stack(
      children: [
        SingleChildScrollView(
          //physics: ScrollPhysics(),
          primary: true,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // TODO: Put all left and right paddings in this outer column
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text("User Playlist",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
                  builder: (context, state) {
                     if (kDebugMode) {
          print("Current state: $state");
        }

        if (state is UserPlaylistLoaded) {
          if (kDebugMode) {
            print("UserPlaylistLoaded: ${state.playlist}");
          }

          return Center(
            child: Text(
              "PlayList: ${state.playlist}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        else if (state is UserPlaylistError) {
          if (kDebugMode) {
            print("UserPlaylistError: ${state.message}");
          } 
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: TextStyle(color: Colors.red),
            ),);
        }
          // return GridView.builder(
                      //   gridDelegate:
                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     mainAxisSpacing: 10,
                      //     crossAxisSpacing: 10,
                      //     childAspectRatio: 3.125,
                      //   ),
                      //   primary: false,
                      //   padding: const EdgeInsets.only(left: 15, right: 15),
                      //   shrinkWrap: true,
                      //   itemCount: 0,
                      //   itemBuilder: (BuildContext context, index) {
                      //     // return recentPlaylistContainer(
                      //     //   name: recentPlaylistItems[index]["name"],
                      //     //   image: recentPlaylistItems[index]["image"],
                      //     //   artistAndPodcastersItems: artistAndPodcastersItems,
                      //     // );
                      //   },
                      // );
                    // Trả về widget mặc định nếu state không phải UserPlaylistLoaded
        // Trả về widget loading nếu state chưa được load
        return const Center(child: CircularProgressIndicator());
      },
                ),
                const Padding(
                    padding: EdgeInsets.only(
                        top: 30, left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text("Recently played",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: "SpotifyCircularBold"),
                          textAlign: TextAlign.left),
                    )),
                // Padding(
                //     padding: const EdgeInsets.only(left: 15, right: 15),
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           for (int i = 0;
                //               i < recentPlayedItems.length;
                //               i++)
                //             recentlyPlayed(
                //                 name: recentPlayedItems[i]['name'],
                //                 image: recentPlayedItems[i]['image'],
                //                 border_radius: recentPlayedItems[i]
                //                     ['border_radius'],
                //                 artistAndPodcastersItems:
                //                   artistAndPodcastersItems),
                //         ],
                //       ),
                //     )),
                const Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Artists and Podcasters",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: "SpotifyCircularBold"),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    )),
                // Padding(
                //     padding: const EdgeInsets.only(left: 15, right: 15),
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           for (int i = 0;
                //               i < artistAndPodcastersItems.length;
                //               i++)
                //             artistAndPodcastersColumn(
                //                 name: artistAndPodcastersItems[i]
                //                     ['name'],
                //                 image: artistAndPodcastersItems[i]
                //                     ['image'],
                //                 border_radius:
                //                     artistAndPodcastersItems[i]
                //                         ['border_radius'],
                //                 artistAndPodcastersItems:
                //                     artistAndPodcastersItems),
                //         ],
                //       ),
                //     )),
                const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: SizedBox(height: 140, width: double.infinity))
              ]),
        ),
        Positioned(
          bottom: 70,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.indigo.shade900,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width - 20,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 46 - 194,
                          height: 20,
                          child: Marquee(
                            text: "Agar Tum Saath Ho (From Tamasha)",
                            style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "SpotifyCircularBold",
                                color: Colors.white),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 70,
                            velocity: 20.0,
                            startPadding: 5.0,
                          )),
                      const Text(
                        "Arijit Singh",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "SpotifyCircularMedium",
                            color: Colors.white),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.devices_sharp, color: Colors.grey)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_outlined,
                          color: Colors.greenAccent[400])),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showDialogBox() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "No internet connection",
                style: TextStyle(
                    fontFamily: "SpotifyCircularBold", color: Colors.white),
              ),
              content: const Text(
                "Turn on mobile data or connect to Wi-Fi.",
                style: TextStyle(
                    fontFamily: "SpotifyCircularLight",
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              backgroundColor: AppColors.darkBackground,
              actionsAlignment: MainAxisAlignment.center,
              surfaceTintColor: Colors.red,
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        textStyle: const TextStyle(
                            fontFamily: "SpotifyCircularBold",
                            color: Colors.white,
                            fontSize: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        fixedSize: const Size(250, 50)),
                    child: const Text("Try Again"))
              ],
            ));
  }
}
