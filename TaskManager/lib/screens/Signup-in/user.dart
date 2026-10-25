import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:studentconnect/Utils/utils.dart';
import 'package:studentconnect/bloc/userBloc/bloc.dart';
import 'package:studentconnect/bloc/userBloc/events.dart';
import 'package:studentconnect/bloc/userBloc/states.dart';
import 'package:studentconnect/constants/colors.dart';
import 'package:studentconnect/constants/fonts.dart';
import 'package:studentconnect/constants/icons.dart';
import 'package:studentconnect/constants/image.dart';
import 'package:studentconnect/data/Authentications/google_signin.dart';
import 'package:studentconnect/routes/routes.dart';
import 'package:studentconnect/widgets/text.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.workspaceGradientColor1[1],
              AppColors.workspaceGradientColor2[1],
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.user,
                  height: Get.height * 0.32,
                  fit: BoxFit.contain,
                ),
            RichText(
              text: TextSpan(
                text: 'Welcome to ',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: AppFonts.normal,
                  fontSize: Get.width * 0.06,
                ),
                children: [
                  const TextSpan(
                      text: 'StudentConnect',
                      style: TextStyle(
                        fontWeight: AppFonts.bold,
                      )),
                ],
              ),
            ),
            text(
              title: "Your academic project collaboration hub!",
              fontSize: Get.width * 0.05,
              fontWeight: AppFonts.normal,
              color: AppColors.white,
              align: TextAlign.center,
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            BlocConsumer<LoginSignUpBloc, UserStates>(
              listener: (context, state) {
                if (state is UserAuthenticated) {
                  Get.offAllNamed(AppRoutes.main);
                } else if (state is UserAuthenticationFailed) {
                  Utils.showtoast(state.error);
                } else if (state is Userloading && state.loading == true) {
                  Utils.showtoast('Signing in...');
                }
              },
              builder: (context, state) {
                if (state is Userloading && state.loading == true) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.white),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Get.width * 0.8,
                      height: Get.height * 0.065,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            color: AppColors.black,
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<LoginSignUpBloc>(context)
                              .add(GoogleSigning(true));
                        },
                        icon: Image.asset(
                          AppIcons.googleLogo,
                          height: Get.height * 0.035,
                        ),
                        label: text(
                          title: 'Continue with Google',
                          fontSize: Get.width * 0.045,
                          fontWeight: AppFonts.semiBold,
                          color: AppColors.black,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.015),
                    SizedBox(
                      width: Get.width * 0.8,
                      height: Get.height * 0.065,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          Utils.showtoast('Entering as Demo Student...');
                          var cred = await Auth.guestSignIn();
                          if (cred != null) {
                            Get.offAllNamed(AppRoutes.main);
                          } else {
                            Get.offAllNamed(AppRoutes.main);
                          }
                        },
                        icon: const Icon(Icons.person_outline, color: AppColors.white),
                        label: text(
                          title: 'Continue as Demo Student',
                          fontSize: Get.width * 0.045,
                          fontWeight: AppFonts.semiBold,
                          color: AppColors.white,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
