import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class DialogWidget extends StatefulWidget {
  final String name;
  final String image;

  const DialogWidget({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0.8), // Adjusted to make the dialog appear higher
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _animation,
          child: DraggableScrollableSheet(
            minChildSize: 0.6, // Adjusted to make the dialog appear higher
            initialChildSize:
                0.6, // Set to match minChildSize to avoid assertion error
            maxChildSize: 1.0, // Allow full-screen expansion
            expand: true,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 26, 26, 26),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              widget.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "739 lượt lưu",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 177, 177, 177)
                            .withOpacity(0.5),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            context
                                  .read<NavigationBloc>()
                                  .add(ChangeTabEvent(3));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Nghe nhạc không quảng cáo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppVectors.logoTuneZWhite,
                                width: 16,
                                height: 16,
                                color: AppColors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Premium",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 26),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 28,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Thêm vào thư viện",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 26),
                      GestureDetector(
                        onTap: (){
                              Navigator.pop(context);
                            context
                                  .read<NavigationBloc>()
                                  .add(ChangeTabEvent(3));
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_down,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Tải xuống",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppVectors.logoTuneZWhite,
                                  width: 16,
                                  height: 16,
                                  color: AppColors.grey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Premium",
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 26),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              size: 28,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Chia sẻ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 26),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.graphic_eq,
                              size: 28,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Hiển thị mã TunezMusic",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 26),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.report_gmailerrorred,
                              size: 28,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Báo cáo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
