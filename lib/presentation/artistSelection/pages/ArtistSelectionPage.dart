import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/artistSelection/widgets/artistItem.dart';

class ArtistSelectionPage extends StatefulWidget {
  const ArtistSelectionPage({super.key});

  @override
  State<ArtistSelectionPage> createState() => _ArtistSelectionPageState();
}

class _ArtistSelectionPageState extends State<ArtistSelectionPage> {
  final List<Map<String, String>> artistList = [
   {"id": "1", "img": "https://i.scdn.co/image/ab67616100005174352d5672d70464e67c3ae963", "name": "Dương Domic"},
  {"id": "2", "img": "https://i.scdn.co/image/ab67616100005174e1cbc9e7ba8fbc5d7738ea51", "name": "HIEUTHUHAI"},
  {"id": "3", "img": "https://i.scdn.co/image/ab676161000051745a79a6ca8c60e4ec1440be53", "name": "Sơn Tùng M-TP"},
  {"id": "4", "img": "https://i.scdn.co/image/ab6761610000517497d758a5602772c33428697e", "name": "ANH TRAI 'SAY HI'"},
  {"id": "5", "img": "https://i.scdn.co/image/ab67616100005174ec6827805882ed3407b8cffd", "name": "ERIK"},
  {"id": "6", "img": "https://i.scdn.co/image/ab676161000051749adfc46417bb7d546b4ab3dd", "name": "buitruonglinh"},
  {"id": "7", "img": "https://i.scdn.co/image/ab676161000051742d7150aa7e90e9a85610ab3d", "name": "Vũ."},
  {"id": "8", "img": "https://i.scdn.co/image/ab6761610000517462c092ca08054a8ce883ef7e", "name": "Da LAB"},
  {"id": "9", "img": "https://i.scdn.co/image/ab67616100005174b9c9e23c646125922719489e", "name": "SOOBIN"},
  {"id": "10", "img": "https://i.scdn.co/image/ab67616100005174230e62752ca87da1d85d0445", "name": "tlinh"},
  {"id": "11", "img": "https://i.scdn.co/image/ab676161000051741a459d6adcd9e8bceba2a5e4", "name": "Vũ Cát Tường"},
  {"id": "12", "img": "https://i.scdn.co/image/ab67616100005174de3d3210433dd11c07678420", "name": "JustaTee"},
  {"id": "13", "img": "https://i.scdn.co/image/ab6761610000517492dc4a2cbffbddb59f825fe0", "name": "Emcee L (Da LAB)"},
  {"id": "14", "img": "https://i.scdn.co/image/ab67616100005174980a220d32409b1164cc9a1d", "name": "Puppy"},
  {"id": "15", "img": "https://i.scdn.co/image/ab67616100005174316c0f0bc6cf3a29c203ab1e", "name": "W/N"},
  {"id": "16", "img": "https://i.scdn.co/image/ab67616100005174fd70279a04a9b3796e7dcd4d", "name": "AMEE"},
  {"id": "17", "img": "https://i.scdn.co/image/ab67616100005174d3d72069ffd18d41b055fa12", "name": "T.R.I"},
  {"id": "18", "img": "https://i.scdn.co/image/ab67616100005174a385bd3e0f67945f277792c2", "name": "Obito"},
  {"id": "19", "img": "https://i.scdn.co/image/ab676161000051745b09f4c3eeb52b57f76dccbc", "name": "Dangrangto"},
  {"id": "20", "img": "https://i.scdn.co/image/ab6761610000517471581ba96c0dfa03f23beeb9", "name": "Shiki"},
  ];

  int displayedItems = 10;
  String searchQuery = '';
  Set<String> selectedArtists = {};
  List<Map<String, String>> filteredList = [];

void toggleSelection(String artistId) {
    setState(() {
      if (selectedArtists.contains(artistId)) {
        selectedArtists.remove(artistId);
      } else {
        selectedArtists.add(artistId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredList = List.from(artistList);
  }

  void updateSearch(String value) {
    setState(() {
      searchQuery = value;
      filteredList = artistList
          .where((artist) => artist["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList()
        ..sort((a, b) => a["name"]!.compareTo(b["name"]!));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasMore = displayedItems < filteredList.length && displayedItems >= 10;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Chọn 3 nghệ sĩ bạn thích trở lên",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // Ô tìm kiếm
            TextField(
              onChanged: updateSearch,
              style: const TextStyle(color: Colors.black),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: "Tìm kiếm nghệ sĩ...",
                hintStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal), // Dễ đọc hơn
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 170,
                ),
                itemCount: hasMore ? displayedItems + 1 : filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < displayedItems) {
                    return ArtistItemSelector(
                      id: filteredList[index]['id']!,
                      image: filteredList[index]['img']!,
                      name: filteredList[index]['name']!,
                      isSelected: selectedArtists.contains(filteredList[index]['id']),
                      onSelect: () => toggleSelection(filteredList[index]['id']!),
                    );
                  } else if (hasMore) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          displayedItems += 10;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, size: 40, color: Colors.black),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
