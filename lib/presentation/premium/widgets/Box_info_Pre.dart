import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class BuildPremiumFeatures extends StatelessWidget {
  const BuildPremiumFeatures({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 31, 31, 31),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Text(
              "Lý do nên dùng gói Premium",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.darkGrey,
          ),
          _buildFeature(Icons.voice_over_off, "Nghe nhạc không quảng cáo"),
          _buildFeature(Icons.download_for_offline_outlined,
              "Tải xuống để nghe không cần mạng"),
          _buildFeature(Icons.auto_mode, "Phát nhạc theo thứ tự bất kỳ"),
          _buildFeature(Icons.graphic_eq_sharp, "Chất lượng âm thanh cao"),
          _buildFeature(
              Icons.people_rounded, "Nghe cùng bạn bè theo thời gian thực"),
          _buildFeature(
              Icons.format_list_bulleted_add, "Sắp xếp danh sách chờ nghe"),
        ],
      ),
    );
  }
}

Widget _buildFeature(IconData icon, String text) {
  return Padding(
    padding: EdgeInsets.only(left: 20, top: 15),
    child: Row(
      children: [
        Icon(icon, size: 28, color: Colors.white),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
