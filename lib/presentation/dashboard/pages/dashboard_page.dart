import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/common/widgets/drawer/nav_left.dart';
import 'package:tunezmusic/presentation/dashboard/pages/home_page.dart';
import 'package:tunezmusic/presentation/dashboard/widgets/sticky_header_delegate.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
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
            floating: true,
            delegate: StickyDashboardHeaderDelegate(
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
