import 'package:flutter/material.dart';

import 'package:womentaxi/untils/export_file.dart';

class SelectFlow extends StatefulWidget {
  const SelectFlow({super.key});

  @override
  State<SelectFlow> createState() => _SelectFlowState();
}

class _SelectFlowState extends State<SelectFlow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kpink.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/pinkCar.png",
              height: MediaQuery.of(context).size.height / 2.3,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 16.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "Please select app type below...",
                style: TextStyle(
                    fontSize: kFourteenFont, color: Kwhite, fontWeight: kFW400),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(KMobileRegistration);
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.all(15.r),
                margin: EdgeInsets.all(16.r),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Kwhite,
                    boxShadow: [
                      BoxShadow(
                        color: Kpink.withOpacity(0.2),
                        blurRadius: 2.r,
                        offset: Offset(1, 1),
                        spreadRadius: 1.r,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: kSixteenFont,
                          color: Kpink,
                          fontWeight: kFW500),
                    ),
                    Text(
                      "Captain Raider",
                      style: TextStyle(
                          fontSize: kSixteenFont,
                          color: Kpink,
                          fontWeight: kFW500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Kpink,
                    )
                  ],
                ),
              ),
            ),
            // CustomButton(
            //     width: 250.w,
            //     height: 42.h,
            //     fontSize: kFourteenFont,
            //     fontWeight: kFW700,
            //     textColor: Kwhite,
            //     borderRadius: BorderRadius.circular(30.r),
            //     label: "Captain",
            //     isLoading: false,
            //     onTap: () async {
            //       Get.toNamed(KMobileRegistration);
            //       //  Get.toNamed(kArrivedScreen);
            //       //  KOtpVerification
            //       //  await Get.toNamed(kOtpVerify);
            //     }),

            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(KMobileRegistration);
                // Get.toNamed(kUserPhoneRegister);
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.all(15.r),
                margin: EdgeInsets.all(16.r),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Kwhite,
                    boxShadow: [
                      BoxShadow(
                        color: Kpink.withOpacity(0.2),
                        blurRadius: 2.r,
                        offset: Offset(1, 1),
                        spreadRadius: 1.r,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: kSixteenFont,
                          color: Kwhite,
                          fontWeight: kFW500),
                    ),
                    Text(
                      "WoR User",
                      style: TextStyle(
                          fontSize: kSixteenFont,
                          color: Kpink,
                          fontWeight: kFW500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Kpink,
                    )
                  ],
                ),
              ),
            ),
            // CustomButton(
            //     width: 250.w,
            //     height: 42.h,
            //     fontSize: kFourteenFont,
            //     fontWeight: kFW700,
            //     textColor: Kwhite,
            //     borderRadius: BorderRadius.circular(30.r),
            //     label: "User",
            //     isLoading: false,
            //     onTap: () async {
            //       // Get.toNamed(kUserDashboard);
            //       //  KOtpVerification
            //       Get.toNamed(kUserPhoneRegister);
            //     }),
            SizedBox(
              height: 50.h,
            ),
            CustomButton(
                width: 250.w,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Biometric",
                isLoading: false,
                onTap: () async {
                  Get.toNamed(kFacialBiometric);
                  //  KOtpVerification
                  // Get.toNamed(kUserPhoneRegister);
                }),
            // SizedBox(
            //   height: 50.h,
            // ),
            // CustomButton(
            //     width: 250.w,
            //     height: 42.h,
            //     fontSize: kFourteenFont,
            //     fontWeight: kFW700,
            //     textColor: Kwhite,
            //     borderRadius: BorderRadius.circular(30.r),
            //     label: "Biometric",
            //     isLoading: false,
            //     onTap: () async {
            //       //  KOtpVerification
            //       Get.toNamed(kFingerPrints);
            //     }),
            SizedBox(
              height: 50.h,
            ),
            CustomButton(
                width: 250.w,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Map Tracking",
                isLoading: false,
                onTap: () async {
                  //  KOtpVerification
                  Get.toNamed(kTrackingScreen);
                }),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                width: 250.w,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Map Tracking",
                isLoading: false,
                onTap: () async {
                  //  KOtpVerification
                  Get.toNamed(kLauncherScreen);
                }),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                width: 250.w,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Map  Merg",
                isLoading: false,
                onTap: () async {
                  //  KOtpVerification
                  Get.toNamed(kMergeMapplsScreen);
                }),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                width: 250.w,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Add Poliline",
                isLoading: false,
                onTap: () async {
                  //  KOtpVerification
                  Get.toNamed(kMappleLocationScreen);
                }),
            //
          ],
        ),
      ),
    );
  }
}
// kMappleLocationScreen