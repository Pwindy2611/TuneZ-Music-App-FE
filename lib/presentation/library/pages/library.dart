import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/drawer/nav_left.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/libraryUI_state.dart';
import 'package:tunezmusic/presentation/library/widgets/add_artist_btn.dart';
import 'package:tunezmusic/presentation/library/widgets/add_podcast_btn.dart';
import 'package:tunezmusic/presentation/library/widgets/save_item_playlist.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: NestedScrollView(
        physics: ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: StickyHeaderLibraryhDelegate(
                      scaffoldKey: _scaffoldKey)
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: state.isGridView ? _buildGridView() : _buildListView(),
            );
          },
        ),
      ),
    );
  }

  /// Hiển thị dạng danh sách (List)
  Widget _buildListView() {
    return ListView(
      children: const [
        SavePlaylistWidget(),
        SizedBox(height: 20),
        AddArtistWidget(),
        SizedBox(height: 20),
        AddPodcastWidget(),
      ],
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      crossAxisCount: 3, 
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.5,
      children: const [
        SavePlaylistWidget(),
        AddArtistWidget(),
        AddPodcastWidget(),
      ],
    );
  }
}
