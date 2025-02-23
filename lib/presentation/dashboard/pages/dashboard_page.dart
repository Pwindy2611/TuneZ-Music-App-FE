import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/common/widgets/drawer/nav_left.dart';
import 'package:tunezmusic/presentation/dashboard/pages/home_page.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/sticky_header_delegate.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_state.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  // List các widget trang
  final List<Widget> _pages = [
    const HomeScreen(), 
    const Page2(),
    const Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      key: _scaffoldKey,
      drawer: const CustomDrawer(), // Sử dụng CustomDrawer
      body: CustomScrollView(
        slivers: [
          // SliverPersistentHeader để tạo header sticky
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyHeaderDelegate(
              scaffoldKey: _scaffoldKey,
              selectedIndexNotifier: _selectedIndexNotifier,
            ),
          ),
          // Nội dung trang sẽ thay đổi dựa trên giá trị của selectedIndex
          SliverFillRemaining(
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return _pages[selectedIndex]; // Hiển thị trang tương ứng
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
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
        
        // Trả về widget loading nếu state chưa được load
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Trang 2",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Trang 3",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
