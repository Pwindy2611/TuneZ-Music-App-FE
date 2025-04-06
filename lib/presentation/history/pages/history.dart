import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_title.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/history/bloc/history_bloc.dart';
import 'package:tunezmusic/presentation/history/bloc/history_event.dart';
import 'package:tunezmusic/presentation/history/bloc/history_state.dart';
import 'package:tunezmusic/presentation/history/widgets/history_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchHistoryEvent());
  }

  void _onTapTrack(String musicId) {
    context.read<MusicBloc>().add(PlayStreamMusic(musicId: musicId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Gần đây",
        titleColor: Colors.white,
        titleSize: 18,
        bgColor: const Color.fromARGB(255, 220, 104, 68),
        onBackPressed: () {
          context.read<NavigationBloc>().add(ClosePlaylistDetailEvent());
        },
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
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
                    child: HistoryItemWidget(
                      tracks: track,
                      prColor: Colors.deepOrangeAccent,
                    ));
              },
            );
          }
          else if(state is NoHistory){
            return Center(
              child: Text("Không có lưu trữ gần đây",style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.bold),),
            );
          }
           else if (state is HistoryError) {
            return Center(
              child: Text("Lỗi: ${state.message}",
                  style: TextStyle(color: Colors.red)),
            );
          }
          return DotsLoading();
        },
      ),
    );
  }
}
