import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/common/widgets/drawer/nav_left.dart';
import 'package:tunezmusic/presentation/search/widgets/item_search_cate.dart';
import 'package:tunezmusic/presentation/search/widgets/item_search_video.dart';
import 'package:tunezmusic/presentation/search/widgets/sticky_bar_delegate.dart';
import 'package:tunezmusic/presentation/search/widgets/sticky_header_delegate.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> video =[
    {
      "id":1,
      "name": "#hopeless romantic",
      "link": "https://stream.mux.com/zmcnsbb63WV4T01VCQc3amcAQkf00Db5PYcLDFPGlgR44.m3u8?t=0.001&max_resolution=720p"
    },
    {
      "id":2,
      "name": "#solace",
      "link": "https://stream.mux.com/GNLpFGGLbyztQQqoA1vPI022hnDJPu02a02i4krH5LBy02o.m3u8?t=0.001&max_resolution=720p"
    },{
      "id":3,
      "name": "#r&b\nhàn quốc",
      "link": "https://stream.mux.com/uXsYv393O5MTKvtYilHj8RXp14BJhEqZnvq5OXFMLAI.m3u8?t=0.001&max_resolution=720p"
    }
  ]; 

  final List<Map<String, dynamic>> listData = [
    {
      "id": 1,
      "color": "rgb(220, 20, 140);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf474a477debc822a3a45c5acb",
      "name": "Nhạc"
    },
    {
      "id": 2,
      "color": "rgb(0, 100, 80);",
      "img": "https://i.scdn.co/image/ab6765630000ba8a81f07e1ead0317ee3c285bfa",
      "name": "Podcasts"
    },
    {
      "id": 3,
      "color": "rgb(132, 0, 231);",
      "img":
          "https://concerts.spotifycdn.com/images/live-events_category-image.jpg",
      "name": "Sự kiện trực tiếp"
    },
    {
      "id": 4,
      "color": "rgb(30, 50, 100);",
      "img": "https://t.scdn.co/images/ea364e99656e46a096ea1df50f581efe",
      "name": "Dành cho bạn"
    },
    {
      "id": 5,
      "color": "rgb(96, 129, 8);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf194fec0fdc197fb9e4fe8e64",
      "name": "Mới phát hành"
    },
    {
      "id": 6,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafe3ace120cac714821f256c93",
      "name": "Nhạc Việt"
    },
    {
      "id": 7,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf66d545e6a69d0bfe8bd1e825",
      "name": "Pop"
    },
    {
      "id": 8,
      "color": "rgb(230, 30, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf4b42030ee01cf793663dbb73",
      "name": "K-Pop"
    },
    {
      "id": 9,
      "color": "rgb(225, 51, 0);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf3c7749936299ad94cce65d83",
      "name": "Hip-Hop"
    },
    {
      "id": 10,
      "color": "rgb(13, 115, 236);",
      "img": "https://t.scdn.co/images/7262179db37c498480ef06bfacb60310.jpeg",
      "name": "Bảng xếp hạng Podcast"
    },
    {
      "id": 11,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67656300005f1fd464f18a416c86ede3a235a7",
      "name": "Sư phạm"
    },
    {
      "id": 12,
      "color": "rgb(80, 55, 80);",
      "img": "https://i.scdn.co/image/ab6765630000ba8a2f514cde3ee9501e7ada4cf4",
      "name": "Tài liệu"
    },
    {
      "id": 13,
      "color": "rgb(175, 40, 150);",
      "img": "https://i.scdn.co/image/ab6765630000ba8a77d267a5accb8911a92668e1",
      "name": "Hài kịch"
    },
    {
      "id": 14,
      "color": "rgb(141, 103, 171);",
      "img":
          "https://charts-images.scdn.co/assets/locale_en/regional/weekly/region_global_default.jpg",
      "name": "Bảng xếp hạng"
    },
    {
      "id": 15,
      "color": "rgb(220, 20, 140);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf7fbae2da432efd2fc985bbf8",
      "name": "Fresh Finds"
    },
    {
      "id": 16,
      "color": "rgb(20, 138, 8);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf7966f50d2abe0636861404ce",
      "name": "EQUAL"
    },
    {
      "id": 17,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf50cfe3fbd3a9fb8810da45ea",
      "name": "GLOW"
    },
    {
      "id": 18,
      "color": "rgb(165, 103, 82);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafd0a58b8ff56eca892982e80c",
      "name": "RADAR"
    },
    {
      "id": 19,
      "color": "rgb(141, 103, 171);",
      "img": "https://t.scdn.co/images/d0fb2ab104dc4846bdc56d72b0b0d785.jpeg",
      "name": "Khám phá"
    },
    {
      "id": 20,
      "color": "rgb(30, 50, 100);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf5530b1833de1f824e5705ffd",
      "name": "Karaoke"
    },
    {
      "id": 21,
      "color": "rgb(225, 17, 140);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafe542e9b59b1d2ae04b46b91c",
      "name": "Tâm trạng"
    },
    {
      "id": 22,
      "color": "rgb(230, 30, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafa0bd564e3f63a4019a5242fb",
      "name": "Rock"
    },
    {
      "id": 23,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf3a44e7ae3d808c220898185c",
      "name": "La-tinh"
    },
    {
      "id": 24,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf26ada793217994216c79dad8",
      "name": "Dance/Điện tử"
    },
    {
      "id": 25,
      "color": "rgb(233, 20, 41);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafa1a252e3a815b65778d8c2aa",
      "name": "Indie"
    },
    {
      "id": 26,
      "color": "rgb(119, 119, 119);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf6af6d83c78493644c9b0627b",
      "name": "Tập luyện"
    },
    {
      "id": 27,
      "color": "rgb(216, 64, 0);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafd10a5fb6da973e53e9d17ab9",
      "name": "Đồng quê"
    },
    {
      "id": 28,
      "color": "rgb(186, 93, 7);",
      "img": "https://i.scdn.co/image/ab67fb8200005caff4e38be86ca48a3b10884ae3",
      "name": "R&B"
    },
    {
      "id": 29,
      "color": "rgb(176, 98, 57);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf330ca3a3bfaf8b18407fb33e",
      "name": "Thư giãn"
    },
    {
      "id": 30,
      "color": "rgb(30, 50, 100);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf1cef0cee1e498abb8e74955f",
      "name": "Ngủ ngon"
    },
    {
      "id": 31,
      "color": "rgb(141, 103, 171);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf0b0d0bfac454671832311615",
      "name": "Tiệc tùng"
    },
    {
      "id": 32,
      "color": "rgb(81, 121, 161);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf60ad5f3ea4988eff993d5e1a",
      "name": "Ở nhà"
    },
    {
      "id": 33,
      "color": "rgb(165, 103, 82);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafb7e805033eb938aa75d09336",
      "name": "Thập niên"
    },
    {
      "id": 34,
      "color": "rgb(220, 20, 140);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf3c8a9f05babcfa50bc59a562",
      "name": "Tình yêu"
    },
    {
      "id": 35,
      "color": "rgb(233, 20, 41);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafefa737b67ec51ec989f5a51d",
      "name": "Metal"
    },
    {
      "id": 36,
      "color": "rgb(141, 103, 171);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafa1bb187ec2f4606aa7101bad",
      "name": "Jazz"
    },
    {
      "id": 37,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf5f54527c0c3abcbd8e5b28f2",
      "name": "Thịnh hành"
    },
    {
      "id": 38,
      "color": "rgb(125, 75, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf4597370d1058e1ec3c1a56fa",
      "name": "Cổ điển"
    },
    {
      "id": 39,
      "color": "rgb(188, 89, 0);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafcc70a3c2e4c71398708bdc4a",
      "name": "Dân gian & Acoustic"
    },
    {
      "id": 40,
      "color": "rgb(165, 103, 82);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf9a27506d5dde68b9da373196",
      "name": "Tập trung"
    },
    {
      "id": 41,
      "color": "rgb(220, 20, 140);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafd82e2c83fe100a89e9cbb2a2",
      "name": "Soul"
    },
    {
      "id": 42,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafe72590f91baff169b1595ab4",
      "name": "Trẻ em & Gia đình"
    },
    {
      "id": 43,
      "color": "rgb(232, 17, 91);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf26dd3719e8824756914ae61f",
      "name": "Chơi game"
    },
    {
      "id": 44,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafef78c123c1bf7d58c6708e89",
      "name": "Anime"
    },
    {
      "id": 45,
      "color": "rgb(20, 138, 8);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf79c2945c8841b281baa35454",
      "name": "TV & Điện ảnh"
    },
    {
      "id": 46,
      "color": "rgb(176, 98, 57);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf192a45a3630deb868c160c9e",
      "name": "Disney"
    },
    {
      "id": 47,
      "color": "rgb(225, 51, 0);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf51565028ee4188dbee2e4aa5",
      "name": "Netflix"
    },
    {
      "id": 48,
      "color": "rgb(83, 122, 161);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf44774504bdbe31a7bc45598c",
      "name": "Nhạc không lời"
    },
    {
      "id": 49,
      "color": "rgb(20, 138, 8);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafd4a8da930bccd56ebd7e48b0",
      "name": "Sức khỏe"
    },
    {
      "id": 50,
      "color": "rgb(230, 30, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf8eebb3e6aa18829dc60f4bc0",
      "name": "Punk"
    },
    {
      "id": 51,
      "color": "rgb(20, 138, 8);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf7d7f89ad0744c51c0f895340",
      "name": "Ambient"
    },
    {
      "id": 52,
      "color": "rgb(230, 30, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf53eb5d52ae9152ce8461b387",
      "name": "Blues"
    },
    {
      "id": 53,
      "color": "rgb(186, 93, 7);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafacbcb985978c387411d69e4f",
      "name": "Nấu nướng & Ăn uống"
    },
    {
      "id": 54,
      "color": "rgb(225, 51, 0);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf106e29a9f294cb4265da6af9",
      "name": "Alternative"
    },
    {
      "id": 55,
      "color": "rgb(39, 133, 106);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf35009e509e1c4c7bb10ff1e4",
      "name": "Du lịch"
    },
    {
      "id": 56,
      "color": "rgb(13, 115, 236);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf8ba1febbb4f77336b6f9aace",
      "name": "Caribe"
    },
    {
      "id": 57,
      "color": "rgb(140, 25, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf73b2872e5a04da17bee68535",
      "name": "Gốc Phi"
    },
    {
      "id": 58,
      "color": "rgb(140, 25, 50);",
      "img": "https://i.scdn.co/image/ab67fb8200005cafb973ab1288f74f333e7e2e22",
      "name": "Nhạc sĩ sáng tác"
    },
    {
      "id": 59,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf71ab47ac71efc219fa2cb171",
      "name": "Thiên nhiên và âm thanh"
    },
    {
      "id": 60,
      "color": "rgb(71, 125, 149);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf3b7919a2cffd1e36647d1c80",
      "name": "Funk"
    },
    {
      "id": 61,
      "color": "rgb(119, 119, 119);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf14030380532b34badbf0a229",
      "name": "Spotify Singles"
    },
    {
      "id": 62,
      "color": "rgb(39, 133, 106);",
      "img": "https://i.scdn.co/image/ab67fb8200005caf097a46192e6bb67e52cdff60",
      "name": "Mùa hè"
    },
    {
      "id": 63,
      "color": "rgb(232, 17, 91);",
      "img": "https://t.scdn.co/images/37732285a0ff4e24987cdf5c45bdf31f.png",
      "name": "Chuyên gia định hướng"
    }
  ];

  Color _parseColor(String rgbString) {
    final regex = RegExp(r"rgb\((\d+), (\d+), (\d+)\)");
    final match = regex.firstMatch(rgbString);
    if (match != null) {
      return Color.fromRGBO(
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
        1,
      );
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
       onTap: () {
        FocusScope.of(context).unfocus(); // Tắt bàn phím khi bấm ra ngoài
      },
      child:Scaffold(
      backgroundColor: AppColors.darkBackground,
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: NestedScrollView(
        physics: ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: StickyHeaderSearchDelegate(scaffoldKey: _scaffoldKey)
                  .build(context, 0, false),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: StickySearchBarDelegate(),
          ),
        ],
        body: CustomScrollView(
          slivers: [
                SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text(
                "Khám phá nội dung mới mẻ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 180,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = video[index];
                  return ItemVideoSearch(
                    name: item["name"],
                    video: item["link"],
                    border_radius:8,
                  );
                },
                childCount: video.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text(
                "Duyệt tìm tất cả",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 100,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= listData.length) {
                    return SizedBox.shrink();
                  }
                  final item = listData[index];
                  return ItemCateSearch(
                    name: item["name"],
                    image: item["img"],
                    border_radius: 8,
                    backgroundColor: _parseColor(item["color"]),
                  );
                },
                childCount: listData.length + 4,
              ),
            ),
          ),
          ],
        ),
      ),
    ));
  }
}
 