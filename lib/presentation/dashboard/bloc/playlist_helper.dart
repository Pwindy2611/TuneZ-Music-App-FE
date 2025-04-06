class PlaylistHelper {
  static List<Map<String, dynamic>> processPlaylistData(dynamic response) {
    if (response['success'] != true ||
        response['data'] is! List ||
        response['data'].isEmpty) {
      throw Exception("API trả về dữ liệu không hợp lệ. $response");
    }

    List<dynamic> rawPlaylists = response['data'];
    List<Map<String, dynamic>> processedCategories = [];

    for (var category in rawPlaylists) {
      if (category is Map<String, dynamic>) {
        for (var categoryName in category.keys) {
          var playlistData = category[categoryName];

          if (playlistData is List) {
            List<Map<String, dynamic>> playlists = [];

            for (var p in playlistData) {
              if (p is Map<String, dynamic>) {
                List<dynamic> tracks = (p["tracks"] is List) ? p["tracks"] : [];
                int totalDuration = tracks.fold(0, (sum, track) {
                  if (track is Map<String, dynamic> &&
                      track.containsKey("duration")) {
                    int duration = track["duration"] is int
                        ? track["duration"]
                        : int.tryParse(track["duration"].toString()) ?? 0;
                    return sum + duration;
                  }
                  return sum;
                });

                playlists.add({
                  "title": p["title"],
                  "coverImage": p["coverImage"],
                  "totalDuration": totalDuration,
                  "tracks": tracks
                });
              }
            }

            processedCategories.add({
              "category": categoryName,
              "playlists": playlists
            });
          }
        }
      }
    }
    return processedCategories;
  }
}
