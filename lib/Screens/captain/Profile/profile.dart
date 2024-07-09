import 'package:womentaxi/untils/export_file.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ApiController apicontroller = Get.put(ApiController());
  UserApiController userapicontroller = Get.put(UserApiController());
  @override
  void initState() {
    apicontroller.getRapidoEmpProfile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kwhite,
        appBar: AppBar(
          backgroundColor: Kwhite,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: KTextdark,
            ),
          ),
          titleSpacing: 0,
          title: Text(
            "Profile",
            style:
                TextStyle(fontSize: 22.sp, color: kcarden, fontWeight: kFW600),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(kEditProfileScreen);
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    fontSize: kSixteenFont, color: kcarden, fontWeight: kFW600),
              ),
            ),
          ],
        ),
        body: Obx(
          () => Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                CircleAvatar(
                  backgroundColor: Kwhite,
                  radius: 50.r,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200.r),
                    child: Image.asset(
                      "assets/images/profileImageStatic.png",
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  apicontroller.profileData["name"] ?? "NA",
                  style: TextStyle(
                      fontSize: 20.sp, color: KdarkText, fontWeight: kFW500),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "4.9",
                              style: TextStyle(
                                  fontSize: kEighteenFont,
                                  fontWeight: kFW500,
                                  color: kcarden),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Image.asset(
                              "assets/images/star_icon.jpg",
                              // height: 150.h,
                              height: 18.h,
                              // width: 100.w,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          "RATING",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW500,
                              color: Ktextcolor),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "165",
                          style: TextStyle(
                              fontSize: kEighteenFont,
                              fontWeight: kFW500,
                              color: kcarden),
                        ),
                        Text(
                          "ORDERS",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW500,
                              color: Ktextcolor),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4",
                          style: TextStyle(
                              fontSize: kEighteenFont,
                              fontWeight: kFW500,
                              color: kcarden),
                        ),
                        Text(
                          "MONTHS",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW500,
                              color: Ktextcolor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 15.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Ktextcolor.withOpacity(0.5),
                        blurRadius: 5.r,
                        offset: Offset(1, 1),
                        spreadRadius: 1.r,
                      )
                    ],
                    color: Kwhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Role",
                        style: TextStyle(
                            fontSize: kSixteenFont,
                            color: KdarkText,
                            fontWeight: kFW500),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          Text(
                            apicontroller.profileData["role"] ?? "NA",
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                color: Ktextcolor,
                                fontWeight: kFW500),
                          ),
                          GestureDetector(
                              onTap: () {
                                // role: “user” or “captain”
                                if (apicontroller.profileData["role"] ==
                                    "user") {
                                  var payload = {"role": "captain"};

                                  // {"mobile": _phoneController.text};
                                  userapicontroller.roleChange(payload,
                                      apicontroller.profileData["mobile"]);
                                } else {
                                  var payload = {"role": "user"};

                                  // {"mobile": _phoneController.text};
                                  userapicontroller.roleChange(payload,
                                      apicontroller.profileData["mobile"]);
                                }
                              },
                              child: Icon(Icons.change_circle)),
                          Text(
                            "Change Role",
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                color: Ktextcolor,
                                fontWeight: kFW500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 15.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Ktextcolor.withOpacity(0.5),
                        blurRadius: 5.r,
                        offset: Offset(1, 1),
                        spreadRadius: 1.r,
                      )
                    ],
                    color: Kwhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: kSixteenFont,
                            color: KdarkText,
                            fontWeight: kFW500),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        apicontroller.profileData["gender"] ?? "NA",
                        style: TextStyle(
                            fontSize: kTwelveFont,
                            color: Ktextcolor,
                            fontWeight: kFW500),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 15.h),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Ktextcolor.withOpacity(0.5),
                        blurRadius: 5.r,
                        offset: Offset(1, 1),
                        spreadRadius: 1.r,
                      )
                    ],
                    color: Kwhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: kSixteenFont,
                            color: KdarkText,
                            fontWeight: kFW500),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        apicontroller.profileData["mobile"] ?? "NA",
                        style: TextStyle(
                            fontSize: kTwelveFont,
                            color: Ktextcolor,
                            fontWeight: kFW500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

    // Obx(
    //   () => Container(
    //     alignment: Alignment.center,
    //     margin: EdgeInsets.all(20.w),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           height: 20.h,
    //         ),
    //         CircleAvatar(
    //           backgroundColor: Kwhite,
    //           radius: 50.r,
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(200.r),
    //             child: Image.asset(
    //               "assets/images/profileImageStatic.png",
    //               height: 100.h,
    //               width: 100.w,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20.h,
    //         ),
    //         Text(
    //           apicontroller.profileData["name"] ?? "NA",
    //           style: TextStyle(
    //               fontSize: 20.sp, color: KdarkText, fontWeight: kFW500),
    //         ),
    //         SizedBox(
    //           height: 20.h,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       "4.9",
    //                       style: TextStyle(
    //                           fontSize: kEighteenFont,
    //                           fontWeight: kFW500,
    //                           color: kcarden),
    //                     ),
    //                     SizedBox(
    //                       width: 5.w,
    //                     ),
    //                     Image.asset(
    //                       "assets/images/star_icon.jpg",
    //                       // height: 150.h,
    //                       height: 18.h,
    //                       // width: 100.w,
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 8.h,
    //                 ),
    //                 Text(
    //                   "RATING",
    //                   style: TextStyle(
    //                       fontSize: 13.sp,
    //                       fontWeight: kFW500,
    //                       color: Ktextcolor),
    //                 ),
    //               ],
    //             ),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "165",
    //                   style: TextStyle(
    //                       fontSize: kEighteenFont,
    //                       fontWeight: kFW500,
    //                       color: kcarden),
    //                 ),
    //                 Text(
    //                   "ORDERS",
    //                   style: TextStyle(
    //                       fontSize: 13.sp,
    //                       fontWeight: kFW500,
    //                       color: Ktextcolor),
    //                 ),
    //               ],
    //             ),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "4",
    //                   style: TextStyle(
    //                       fontSize: kEighteenFont,
    //                       fontWeight: kFW500,
    //                       color: kcarden),
    //                 ),
    //                 Text(
    //                   "MONTHS",
    //                   style: TextStyle(
    //                       fontSize: 13.sp,
    //                       fontWeight: kFW500,
    //                       color: Ktextcolor),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //         SizedBox(
    //           height: 10.h,
    //         ),
    //         Divider(),
    //         Container(
    //           width: double.infinity,
    //           margin: EdgeInsets.only(top: 15.h),
    //           padding: EdgeInsets.all(10.r),
    //           decoration: BoxDecoration(
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Ktextcolor.withOpacity(0.5),
    //                 blurRadius: 5.r,
    //                 offset: Offset(1, 1),
    //                 spreadRadius: 1.r,
    //               )
    //             ],
    //             color: Kwhite,
    //             borderRadius: BorderRadius.circular(10.r),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Role",
    //                 style: TextStyle(
    //                     fontSize: kSixteenFont,
    //                     color: KdarkText,
    //                     fontWeight: kFW500),
    //               ),
    //               SizedBox(
    //                 height: 8.h,
    //               ),
    //               Text(
    //                 apicontroller.profileData["role"] ?? "NA",
    //                 style: TextStyle(
    //                     fontSize: kTwelveFont,
    //                     color: Ktextcolor,
    //                     fontWeight: kFW500),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           width: double.infinity,
    //           margin: EdgeInsets.only(top: 15.h),
    //           padding: EdgeInsets.all(10.r),
    //           decoration: BoxDecoration(
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Ktextcolor.withOpacity(0.5),
    //                 blurRadius: 5.r,
    //                 offset: Offset(1, 1),
    //                 spreadRadius: 1.r,
    //               )
    //             ],
    //             color: Kwhite,
    //             borderRadius: BorderRadius.circular(10.r),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Gender",
    //                 style: TextStyle(
    //                     fontSize: kSixteenFont,
    //                     color: KdarkText,
    //                     fontWeight: kFW500),
    //               ),
    //               SizedBox(
    //                 height: 8.h,
    //               ),
    //               Text(
    //                 apicontroller.profileData["gender"] ?? "NA",
    //                 style: TextStyle(
    //                     fontSize: kTwelveFont,
    //                     color: Ktextcolor,
    //                     fontWeight: kFW500),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           width: double.infinity,
    //           margin: EdgeInsets.only(top: 15.h),
    //           padding: EdgeInsets.all(10.r),
    //           decoration: BoxDecoration(
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Ktextcolor.withOpacity(0.5),
    //                 blurRadius: 5.r,
    //                 offset: Offset(1, 1),
    //                 spreadRadius: 1.r,
    //               )
    //             ],
    //             color: Kwhite,
    //             borderRadius: BorderRadius.circular(10.r),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "Phone Number",
    //                 style: TextStyle(
    //                     fontSize: kSixteenFont,
    //                     color: KdarkText,
    //                     fontWeight: kFW500),
    //               ),
    //               SizedBox(
    //                 height: 8.h,
    //               ),
    //               Text(
    //                 apicontroller.profileData["mobile"] ?? "NA",
    //                 style: TextStyle(
    //                     fontSize: kTwelveFont,
    //                     color: Ktextcolor,
    //                     fontWeight: kFW500),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ));
  }
}
