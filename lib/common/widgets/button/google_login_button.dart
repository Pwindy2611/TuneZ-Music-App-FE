 import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';
import 'package:tunezmusic/presentation/login/bloc/login_state.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';

Widget resByGoogle(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicAppOlButton(
          title: 'Tiếp tục bằng Google',
          outlineColor: null,
          colors: Colors.white,
          icon: AppImages.googleIcon,
          onPressed: () {
            context.read<LoginBloc>().add(SignInWithGoogleEvent());
          },
          textSize: 17,
          height: 52,
        );
      },
    );
  }