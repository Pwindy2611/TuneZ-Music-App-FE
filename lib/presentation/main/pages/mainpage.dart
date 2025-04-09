import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/data/services/authManager.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_event.dart';
import 'package:tunezmusic/presentation/library/bloc/music_love_list_state.dart';
import 'package:tunezmusic/presentation/music/widgets/MusicPlayerWidget.dart';
import 'package:tunezmusic/presentation/dashboard/pages/dashboard_page.dart';
import 'package:tunezmusic/presentation/history/pages/history.dart';
import 'package:tunezmusic/presentation/library/pages/library.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_bloc.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_event.dart';
import 'package:tunezmusic/presentation/library/bloc/artist_follow_state.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_bloc.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_event.dart';
import 'package:tunezmusic/presentation/dashboard/bloc/user_playlist_state.dart';
import 'package:tunezmusic/presentation/main/widgets/item_bottom_nav.dart';
import 'package:tunezmusic/presentation/playlistLove/pages/playList_Love.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_event.dart';
import 'package:tunezmusic/presentation/premium/bloc/subscriptions_state.dart';
import 'package:tunezmusic/presentation/premium/pages/premium.dart';
import 'package:tunezmusic/presentation/search/pages/search.dart';
import 'package:tunezmusic/presentation/search/pages/search_page.dart';
import 'package:tunezmusic/presentation/user_music/pages/user_music_page.dart' show UserMusicPage;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = true;
  String? userId;
  bool _isInitialized = false;
  late AppLinks _appLinks;
  final AuthManager auth = AuthManager();

  static final List<Widget> _widgetOptions = [
    const DashboardWidget(),
    const SearchWidget(),
    const LibraryWidget(),
    const PremiumWidget(),
    const HistoryPage(),
    const PlayListLovePage(),
    const SearchPage(),
    const UserMusicPage(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _initDeepLinks();
  }

   Future<void> _initDeepLinks() async {
    try {
      if (!_isInitialized) {
        print('Initializing AppLinks...');
        _appLinks = AppLinks();
        
        // Handle deep link when app is started
        final appLink = await _appLinks.getInitialAppLink();
        print('Initial deep link: $appLink');
        if (appLink != null) {
          print('Processing initial deep link...');
          _handleDeepLink(appLink);
        }

        // Handle deep link when app is in foreground
        print('Setting up URI stream listener...');
        _appLinks.uriLinkStream.listen(
          (uri) {
            print('Received URI from stream: $uri');
            _handleDeepLink(uri);
          },
          onError: (err) {
            print('Error in URI stream: $err');
          },
        );

        _isInitialized = true;
        print('AppLinks initialization completed');
      }
    } catch (e) {
      print('Error in _initDeepLinks: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    print('_handleDeepLink called with URI: $uri');
    print('Scheme: ${uri.scheme}');
    print('Host: ${uri.host}');
    print('Path: ${uri.path}');
    print('Query parameters: ${uri.queryParameters}');

    if (uri.scheme == 'tunezmusic' && uri.host == 'payment-callback') {
      print('Valid payment callback URI detected');
      
      final resultCode = int.tryParse(uri.queryParameters['resultCode'] ?? '-1');
      final message = uri.queryParameters['message'] ?? 'Unknown status';
      
      // Show dialog based on resultCode
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final isSuccess = resultCode == 0;
          
          return AlertDialog(
            backgroundColor: Colors.black87,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  isSuccess ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Mã đơn hàng: ${uri.queryParameters['orderId']}',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Số tiền: ${uri.queryParameters['amount']} VNĐ',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess ? Colors.green : Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isSuccess ? 'OK' : 'Hủy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      try {
        // Continue with normal payment processing
        context.read<PaymentBloc>().handleDeepLink(uri);
        print('Payment processing completed');
      } catch (e) {
        print('Error processing payment: $e');
      }
    } else {
      print('URI did not match expected scheme/host');
      print('Expected: TuneZMusic://payment-callback');
      print('Received: ${uri.scheme}://${uri.host}');
    }
  }

Future<void> _fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final savedUserId = prefs.getString('userId');
  final savedToken = prefs.getString('token');

  if (kDebugMode) print('Saved User ID: $savedUserId');

  if (savedUserId == null || savedUserId.isEmpty || savedToken == null) {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    return;
  }

  final userPlaylistBloc = context.read<HomePlaylistBloc>();
  final artistFollowBloc = context.read<ArtistFollowBloc>();
  final musicBloc = context.read<MusicBloc>();
  final paymentBloc = context.read<SubscriptionsBloc>();
  final musicLoveList = context.read<MusicLoveListBloc>();

  bool shouldWait = false;
  int retryCount = 0;
  const maxRetries = 3;

  while (retryCount < maxRetries) {
    try {
      shouldWait = false;

      if (userPlaylistBloc.state is HomePlaylistInitial) {
        userPlaylistBloc.add(FetchHomePlaylistEvent(savedUserId));
        shouldWait = true;
      }
      if (artistFollowBloc.state is ArtistFollowInitial) {
        artistFollowBloc.add(FetchArtistFollowEvent(savedUserId));
        shouldWait = true;
      }
      if (musicBloc.state is MusicInitial) {
        musicBloc.add(LoadUserMusicState());
        shouldWait = true;
      }
      if (paymentBloc.state is SubscriptionsInitial) {
        paymentBloc.add(FetchSubscriptions());
        shouldWait = true;
      }
      if (musicLoveList.state is MusicLoveListInitial) {
        musicLoveList.add(FetchMusicLoveListEvent());
        shouldWait = true;
      }

      if (shouldWait) {
        await _waitForBlocsToComplete(
            [userPlaylistBloc, artistFollowBloc, musicBloc, paymentBloc, musicLoveList]);
      }

      // Nếu không có lỗi, thoát khỏi vòng lặp
      break;
    } catch (e) {
      retryCount++;
      if (retryCount == maxRetries) {
        print('Failed to fetch data after $maxRetries attempts: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }
      // Đợi một khoảng thời gian trước khi thử lại
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  if (mounted) {
    setState(() {
      userId = savedUserId;
      isLoading = false;
    });
  }
}

Future<void> _waitForBlocsToComplete(List<Bloc> blocs) async {
  final completer = Completer<void>();
  bool hasError = false;

  void checkStates() {
    for (final bloc in blocs) { 
      if (bloc.state is HomePlaylistLoading ||
          bloc.state is ArtistFollowLoading ||
          bloc.state is MusicLoading ||
          bloc.state is SubscriptionsLoading) {
        return;
      }
      if (bloc.state is HomePlaylistError ||
          bloc.state is ArtistFollowError ||
          bloc.state is SubscriptionsFailure) {
        hasError = true;
        return;
      }
    }
    if (!completer.isCompleted) completer.complete();
  }

  for (final bloc in blocs) {
    bloc.stream.listen((_) => checkStates());
  }

  await completer.future;
  
  if (hasError) {
    throw Exception('One or more blocs encountered an error');
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final navBloc = context.read<NavigationBloc>();
        if (navBloc.state.playlistDetail != null || navBloc.state.artistDetail != null) {
          navBloc.add(ChangeTabEvent(0));
          return false;
        }
        if (navBloc.state.selectedIndex != 0) {
          navBloc.add(ChangeTabEvent(0));
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,  
        backgroundColor: AppColors.darkBackground,
        body: isLoading
            ? DotsLoading()
            : Stack(
                children: [
                  BlocBuilder<NavigationBloc, NavigationState>(
                      builder: (context, state) {
                    return Stack(children: [
                      Positioned.fill(
                          child: state.playlistDetail != null
                              ? state.playlistDetail!
                              : state.artistDetail != null
                                  ? state.artistDetail!
                                  : IndexedStack(
                                      index: state.selectedIndex,
                                      children: _widgetOptions,
                                    )),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 0, 0, 0),
                                    Color.fromARGB(178, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              alignment: Alignment.bottomCenter,
                              child: BottomNavigationBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  type: BottomNavigationBarType.fixed,
                                  items: [
                                    {
                                      'index': 0,
                                      'icon': AppVectors.iconHome,
                                      'focusedIcon': AppVectors.iconHomeFocus,
                                      'label': 'Trang chủ',
                                    },
                                    {
                                      'index': 1,
                                      'icon': AppVectors.iconSearch,
                                      'focusedIcon': AppVectors.iconSearchFocus,
                                      'label': 'Tìm kiếm',
                                    },
                                    {
                                      'index': 2,
                                      'icon': AppVectors.iconLibrary,
                                      'focusedIcon':
                                          AppVectors.iconLibraryFocus,
                                      'label': 'Thư viện',
                                    },
                                    {
                                      'index': 3,
                                      'icon': AppVectors.iconPremium,
                                      'focusedIcon':
                                          AppVectors.iconPremiumFocus,
                                      'label': 'Premium',
                                    },
                                  ].map((item) {
                                    return buildBottomNavItem(
                                      index: item['index'] as int,
                                      icon: item['icon'] as String,
                                      focusedIcon:
                                          item['focusedIcon'] as String,
                                      label: item['label'] as String,
                                      selectedIndex: context
                                          .watch<NavigationBloc>()
                                          .state
                                          .selectedIndex,
                                      tappedIndex: state.selectedIndex,
                                      onItemTapped: (index) {
                                        context
                                            .read<NavigationBloc>()
                                            .add(ChangeTabEvent(index));
                                      },
                                    );
                                  }).toList(),
                                  currentIndex: state.selectedIndex > 3
                                      ? 0
                                      : state.selectedIndex,
                                  selectedItemColor: Colors.white,
                                  unselectedItemColor: Colors.grey,
                                  selectedLabelStyle:
                                      const TextStyle(fontSize: 11),
                                  unselectedLabelStyle:
                                      const TextStyle(fontSize: 11),
                                  onTap: (index) {
                                    context
                                        .read<NavigationBloc>()
                                        .add(ChangeTabEvent(index));
                                  }))),
                    ]);
                  }),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom:
                        65,
                    child: MusicPlayerWidget(),
                  ),
                ],
              ),
      ),
    );
  }
}
