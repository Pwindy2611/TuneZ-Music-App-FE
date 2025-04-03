import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/drawer/nav_left.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_state.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_state.dart';
import 'package:tunezmusic/presentation/library/widgets/add_artist_btn.dart';
import 'package:tunezmusic/presentation/library/widgets/add_podcast_btn.dart';
import 'package:tunezmusic/presentation/library/widgets/artist_follow_item.dart';
import 'package:tunezmusic/presentation/library/widgets/save_item_playlist.dart';
import 'package:tunezmusic/presentation/library/widgets/save_love_playlist.dart';
import 'package:tunezmusic/presentation/library/widgets/sticky_header_delegate.dart';
import 'package:tunezmusic/presentation/library/widgets/sticky_header_optionNav.dart';
import 'package:tunezmusic/presentation/library/widgets/sticky_headder_filter.dart';

class LibraryWidget extends StatefulWidget {
  const LibraryWidget({super.key});

  @override
  _LibraryWidgetState createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _selectedValueNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: StickyHeaderLibraryDelegate(scaffoldKey: _scaffoldKey)
                  .build(context, 0, false),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyHeaderOptionNavDelegate(
              selectedIndexNotifier: _selectedIndexNotifier,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyHeaderFilterDelegate(
              selectedIndexNotifier: _selectedValueNotifier,
            ),
          ),
        ],
        body: BlocBuilder<LibraryUIBloc, LibraryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ArtistFollowBloc, ArtistFollowState>(
                builder: (context, artistState) {
                  if (artistState is ArtistFollowLoading) {
                    return DotsLoading();
                  } else if (artistState is ArtistFollowLoaded) {
                    if (kDebugMode) {
                      print(artistState.artistList);
                    }
                    return state.isGridView
                        ? _buildGridView(artistState.artistList)
                        : _buildListView(artistState.artistList);
                  }
                  return Padding(padding: EdgeInsets.all(0));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<dynamic> artistList) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return ListView(
          children: [
            BlocBuilder<MusicLoveListBloc, MusicLoveListState>(
                builder: (context, musicLoveState) {
              final hasMusicLoveData = musicLoveState is MusicLoveListLoaded &&
                  musicLoveState.musicList.isNotEmpty;
              if ((selectedIndex == 1 || selectedIndex == 0) &&
                  hasMusicLoveData) {
                return SaveLovePlaylistWidget();
              }
              return SizedBox
                  .shrink(); // Trả về widget rỗng nếu không có dữ liệu
            }),
            const SizedBox(height: 20),
            if (selectedIndex == 3 || selectedIndex == 0) ...[
              if (artistList.isNotEmpty)
                ...artistList.map((artist) => Column(
                      children: [
                        ArtistFollowItem(
                          callback: () {
                            context.read<NavigationBloc>().add(
                                OpenArtistDetailEvent(
                                    artist['img'], artist['name']));
                          },
                          name: artist['name'] ?? 'Unknown Artist',
                          image: artist['img'] ?? '',
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),
            ],
            if (selectedIndex == 1 || selectedIndex == 0) ...[
              const SavePlaylistWidget(),
              const SizedBox(height: 20),
            ],
            if (selectedIndex == 2 || selectedIndex == 0) ...[
              const AddPodcastWidget(),
              const SizedBox(height: 20),
            ],
            if (selectedIndex == 3 || selectedIndex == 0)
              const AddArtistWidget(),
            const SizedBox(height: 200),
          ],
        );
      },
    );
  }

  Widget _buildGridView(List<dynamic> artistList) {
    return BlocBuilder<MusicLoveListBloc, MusicLoveListState>(
        builder: (context, musicLoveState) {
      final hasMusicLoveData = musicLoveState is MusicLoveListLoaded &&
          musicLoveState.musicList.isNotEmpty;
      return ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, selectedIndex, child) {
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
            children: [
              if ((selectedIndex == 1 || selectedIndex == 0) &&
                  hasMusicLoveData)
                SaveLovePlaylistWidget(),
              if (selectedIndex == 3 || selectedIndex == 0) ...[
                if (artistList.isNotEmpty)
                  ...artistList.map((artist) => ArtistFollowItem(
                        callback: () {
                          context.read<NavigationBloc>().add(
                              OpenArtistDetailEvent(
                                  artist['img'], artist['name']));
                        },
                        name: artist['name'] ?? 'Unknown Artist',
                        image: artist['img'] ?? '',
                      )),
              ],
              if (selectedIndex == 1 || selectedIndex == 0)
                const SavePlaylistWidget(),
              if (selectedIndex == 2 || selectedIndex == 0)
                const AddPodcastWidget(),
              if (selectedIndex == 3 || selectedIndex == 0)
                const AddArtistWidget(),
            ],
          );
        },
      );
    });
  }
}
