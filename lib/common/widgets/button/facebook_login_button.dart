import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';

Widget resByFacebook(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicAppOlButton(
          title: 'Tiếp tục bằng Facebook',
          outlineColor: null,
          colors: Colors.white,
          icon: AppImages.facebookIcon,
          onPressed: () {
            context.read<LoginBloc>().add(SignInWithFacebookEvent());
          },
          textSize: 17,
          height: 52,
        );
      },
    );
  }