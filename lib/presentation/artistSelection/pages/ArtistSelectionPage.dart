import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_bloc.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_event.dart';
import 'package:tunezmusic/presentation/artistSelection/bloc/ArtistSelection_state.dart';
import 'package:tunezmusic/presentation/artistSelection/widgets/artistItem.dart';
import 'package:tunezmusic/presentation/artistSelection/widgets/dialog_button.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';

class ArtistSelectionPage extends StatefulWidget {
  const ArtistSelectionPage({super.key});

  @override
  State<ArtistSelectionPage> createState() => _ArtistSelectionPageState();
}

class _ArtistSelectionPageState extends State<ArtistSelectionPage> {
  List<Map<String, String>> artistList = [];
  int displayedItems = 10;
  String searchQuery = '';
  Set<String> selectedArtists = {};
  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    context.read<ArtistSelectionBloc>().add(ArtistSelectionFetchEvent());
  }

  void toggleSelection(String artistId) {
    setState(() {
      if (selectedArtists.contains(artistId)) {
        selectedArtists.remove(artistId);
      } else {
        selectedArtists.add(artistId);
      }
    });
  }

  void updateSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredList = artistList
          .where((artist) =>
              artist["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList()
        ..sort((a, b) => a["name"]!.compareTo(b["name"]!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Tắt bàn phím khi bấm ra ngoài
      },
      child: BlocBuilder<ArtistSelectionBloc, ArtistSelectionState>(
        builder: (context, state) {
          if (state is ArtistSelectionFetchSuccessState) {
            if (artistList.isEmpty) {
              artistList = state.listArtist
                  .map((artist) => {
                        "id": artist["id"] as String,
                        "name": artist["name"] as String,
                        "img": artist["img"] as String,
                      })
                  .toList();
              filteredList = List.from(artistList);
            }
            bool hasMore =
                displayedItems < filteredList.length && displayedItems >= 10;

            return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Chọn 3 nghệ sĩ bạn thích trở lên",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),

                        // Ô tìm kiếm
                        TextField(
                          onChanged: updateSearch,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm nghệ sĩ...",
                            hintStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 170,
                            ),
                            itemCount: hasMore
                                ? displayedItems + 1
                                : filteredList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < displayedItems) {
                                return ArtistItemSelector(
                                  id: filteredList[index]['id']!,
                                  image: filteredList[index]['img']!,
                                  name: filteredList[index]['name']!,
                                  isSelected: selectedArtists
                                      .contains(filteredList[index]['id']),
                                  onSelect: () => toggleSelection(
                                      filteredList[index]['id']!),
                                );
                              } else if (hasMore) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      displayedItems += 10;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.add,
                                        size: 40, color: Colors.black),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20, // Cách đáy màn hình 20px
                    left: 100,
                    right: 100,
                    child: AnimatedSlide(
                      offset: selectedArtists.length >= 3
                          ? Offset(0, 0)
                          : Offset(0, 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut, // Làm mượt hiệu ứng trượt
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: selectedArtists.length >= 3 ? 1.0 : 0.0,
                        child: ButtonBottomDialog(
                          onPressed: () {
                            context.read<ArtistSelectionBloc>().add(
                                  ArtistSelectionPostEvent(
                                      selectedArtists.toList()),
                                );
                          },
                        ),
                      ),
                    ),
                  ),
                ]));
          }
          if (state is ArtistSelectionFetchPostState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainPage()),
              );
            });
          }
          return DotsLoading();
        },
      ),
    );
  }
}
