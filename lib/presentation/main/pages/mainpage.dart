import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/dashboard/pages/dashboard_page.dart';
import 'package:tunezmusic/presentation/library/pages/library.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/main/bloc/user_playlist_event.dart';
import 'package:tunezmusic/presentation/main/widgets/item_bottom_nav.dart';
import 'package:tunezmusic/presentation/premium/pages/premium.dart';
import 'package:tunezmusic/presentation/search/pages/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int? _tappedIndex;
  bool isLoading = true;
  String? userId;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    SearchWidget(),
    LibraryWidget(),
    PremiumWidget(),
  ];

  @override
  void initState() {
    super.initState();
   _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId') ?? '';

    if (kDebugMode) {
      print('Saved User ID: $savedUserId');
    }

    if (savedUserId.isNotEmpty) {
      final userPlaylistBloc = context.read<UserPlaylistBloc>();
      userPlaylistBloc.add(FetchUserPlaylistEvent(savedUserId));
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        userId = savedUserId.isNotEmpty ? savedUserId : null;
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tappedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _tappedIndex = null);
      }
    });
  }

  final bottomNavItems = [
    {'index': 0, 'icon': AppVectors.iconHome, 'focusedIcon': AppVectors.iconHomeFocus, 'label': 'Trang chủ'},
    {'index': 1, 'icon': AppVectors.iconSearch, 'focusedIcon': AppVectors.iconSearchFocus, 'label': 'Tìm kiếm'},
    {'index': 2, 'icon': AppVectors.iconLibrary, 'focusedIcon': AppVectors.iconLibraryFocus, 'label': 'Thư viện'},
    {'index': 3, 'icon': AppVectors.iconPremium, 'focusedIcon': AppVectors.iconPremiumFocus, 'label': 'Premium'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(index: _selectedIndex, children: _widgetOptions),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Container(
                      height: 110,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(157, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: BottomNavigationBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        type: BottomNavigationBarType.fixed,
                        items: bottomNavItems.map((item) {
                          return buildBottomNavItem(
                            index: item['index'] as int,
                            icon: item['icon'] as String,
                            focusedIcon: item['focusedIcon'] as String,
                            label: item['label'] as String,
                            selectedIndex: _selectedIndex,
                            tappedIndex: _tappedIndex,
                            onItemTapped: _onItemTapped,
                          );
                        }).toList(),
                        currentIndex: _selectedIndex,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.grey,
                        selectedLabelStyle: const TextStyle(fontSize: 11, color: Colors.white),
                        unselectedLabelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                        onTap: _onItemTapped,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
