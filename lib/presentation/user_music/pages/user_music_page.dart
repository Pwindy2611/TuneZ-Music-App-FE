import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_bloc.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_event.dart';
import 'package:tunezmusic/presentation/user_music/bloc/user_music_state.dart';
import 'package:tunezmusic/presentation/user_music/widgets/userMusic_item.dart';

class UserMusicPage extends StatefulWidget {
  const UserMusicPage({super.key});

  @override
  State<UserMusicPage> createState() => _UserMusicPageState();
}

class _UserMusicPageState extends State<UserMusicPage> {
  late UserMusicBloc _userMusicBloc;

  @override
  void initState() {
    super.initState();
    _userMusicBloc = UserMusicBloc(ApiService());
    _userMusicBloc.add(FetchUserMusic());
  }

  @override
  void dispose() {
    _userMusicBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _userMusicBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhạc đã đăng tải',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<NavigationBloc>().add(ClosePlaylistDetailEvent());
            },
          ),
        ),
        body: BlocBuilder<UserMusicBloc, UserMusicState>(
          builder: (context, state) {
            if (state is UserMusicLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserMusicLoaded) {
                return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: state.tracks.length + 2,
              itemBuilder: (context, index) {
                if (index >= state.tracks.length) {
                  return const SizedBox(height: 100);
                }
                final track = state.tracks[index];
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: UserMusicItemWidget(
                      tracks: track,
                      prColor: Colors.blue,
                    ));
              },
            );
            }
            return const Center(child: Text('Bạn chưa đăng tải bài hát nào'));
          },
        ),
      ),
    );
  }
} 