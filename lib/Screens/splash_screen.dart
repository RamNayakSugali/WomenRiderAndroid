import 'package:flutter/material.dart';

import 'package:womentaxi/untils/export_file.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ApiController apiController = Get.put(ApiController());
  bool? isUserLoggedIn;
  @override
  void initState() {
    super.initState();

    isUserLoggedIn = UserSimplePreferences.getLoginStatus();
    Future.delayed(const Duration(seconds: 2), () async {
      if (isUserLoggedIn != null && isUserLoggedIn == true) {
        await apiController.getRapidoEmpProfile();
        apiController.profileData["role"] == "captain"
            ?

            //     ? Get.toNamed(kNavigation)
            //     : Get.toNamed(kDonorBottomNavigation);

            Get.toNamed(KDashboard)
            : Get.toNamed(kUserDashboard);
      } else {
        Get.toNamed(KOnboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/ladyrider.png",
              height: 200.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Woman Rapido",
              style: TextStyle(
                  fontSize: kTwentyFont, color: kcarden, fontWeight: kFW600),
            ),
          ],
        ),
      ),
    );
  }
}
