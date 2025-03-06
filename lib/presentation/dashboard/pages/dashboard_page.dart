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
