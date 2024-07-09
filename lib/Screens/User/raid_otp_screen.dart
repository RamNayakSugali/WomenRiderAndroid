// import 'package:womentaxi/untils/export_file.dart';

// class RaidOtp extends StatefulWidget {
//   const RaidOtp({super.key});

//   @override
//   State<RaidOtp> createState() => _RaidOtpState();
// }

// ignore_for_file: depend_on_referenced_packages

// class _RaidOtpState extends State<RaidOtp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

import 'package:womentaxi/untils/export_file.dart';
import 'package:womentaxi/untils/export_file.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mappls_direction_plugin/mappls_direction_plugin.dart';
import 'package:womentaxi/untils/constants.dart';
import 'package:womentaxi/untils/export_file.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mappls_flutter_sdk/utils/color.dart';
// import 'package:mappls_flutter_sdk/utils/polyline.dart';
import 'package:mappls_gl/mappls_gl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mappls_gl/mappls_gl.dart';
import 'package:womentaxi/untils/export_file.dart';

class RaidOtp extends StatefulWidget {
  const RaidOtp({super.key});

  @override
  State<RaidOtp> createState() => _RaidOtpState();
}

class _RaidOtpState extends State<RaidOtp> {
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );
  ApiController apicontroller = Get.put(ApiController());
  UserApiController userapicontroller = Get.put(UserApiController());
  ApiController authentication = Get.put(ApiController());
  late MapplsMapController controller;
  List<String> profile = [
    DirectionCriteria.PROFILE_DRIVING,
    DirectionCriteria.PROFILE_BIKING,
    DirectionCriteria.PROFILE_WALKING,
  ];
  List<ResourceList> resource = [
    ResourceList(DirectionCriteria.RESOURCE_ROUTE, "Non Traffic"),
    ResourceList(DirectionCriteria.RESOURCE_ROUTE_ETA, "Route ETA"),
    ResourceList(DirectionCriteria.RESOURCE_ROUTE_TRAFFIC, "Traffic"),
  ];
  int selectedIndex = 0;
  late ResourceList selectedResource;
  DirectionsRoute? route;
  int _rating = 4;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedResource = resource[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd-MM-yyyy").format(now);
    String formattedTime = DateFormat("hh:mm a").format(now);
    return Scaffold(
      backgroundColor: Kwhite,
      body: 
      SlidingSheet(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Kwhite,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r)),
                  child: Column(children: [
                    Expanded(
                        child: Stack(children: [
                      MapplsMap(
                        initialCameraPosition: _kInitialPosition,
                        onMapCreated: (map) => {
                          controller = map,
                        },
                        onStyleLoadedCallback: () => {callDirection()},
                      ),
                      SizedBox(
                        height: 0.h,
                        child: Column(
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: DefaultTabController(
                                  length: 3,
                                  child: TabBar(
                                    tabs: const [
                                      Tab(
                                        icon: Icon(Icons.directions_car),
                                        text: "Driving",
                                      ),
                                      Tab(
                                        icon: Icon(Icons.directions_bike),
                                        text: "Biking",
                                      ),
                                      Tab(
                                        icon: Icon(Icons.directions_walk),
                                        text: "Walking",
                                      )
                                    ],
                                    onTap: (value) => {
                                      setState(() {
                                        selectedIndex = value;
                                      }),
                                      if (value != 0)
                                        {selectedResource = resource[0]},
                                      callDirection()
                                    },
                                    labelColor: Colors.blue,
                                    unselectedLabelColor: Colors.black,
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            selectedIndex == 0
                                ? Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: resource
                                          .map((data) => Expanded(
                                              child: RadioListTile(
                                                  title: Text(
                                                    data.text,
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  value: selectedResource,
                                                  groupValue: data,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      selectedResource = data;
                                                    });
                                                    callDirection();
                                                  })))
                                          .toList(),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      )
                    ])),
                    route != null
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Text(
                              getDurationAndDistance(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          )
                        : Container()
                  ]),
                ),
              )
            ],
          ),
        ),
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.all(15.r),
            color: Kwhite,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Obx(() => userapicontroller.listenOrders["message"] ==
                    "Your Ride is completed...!"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StarRating(
                        rating: _rating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                      CustomFormField(
                        enabled: true,
                        controller:
                            authentication.registerDonorfirstNameController,
                        obscureText: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        fontSize: kFourteenFont,
                        fontWeight: FontWeight.w500,
                        hintText: "Enter User Experience",
                        maxLines: 1,
                        readOnly: false,
                        label: 'Experience',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Experience';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                          margin: EdgeInsets.only(top: 35.h),
                          width: double.infinity,
                          height: 42,
                          fontSize: kFourteenFont,
                          fontWeight: kFW700,
                          textColor: Kwhite,
                          borderRadius: BorderRadius.circular(30.r),
                          label: "Give Rating",
                          isLoading: false,
                          onTap: () async {
                            var payload = {
                              "reviewRating": _rating,
                              "reviewTest": authentication
                                  .registerDonorfirstNameController.text,
                            };
                            userapicontroller.reviewOrder(payload);
                            // Get.toNamed(kUserDashboard);
                            //  KOtpVerification
                            //  await Get.toNamed(kOtpVerify);
                          }),
                      CustomButton(
                          margin: EdgeInsets.only(top: 35.h),
                          width: double.infinity,
                          height: 42,
                          fontSize: kFourteenFont,
                          fontWeight: kFW700,
                          textColor: Kwhite,
                          borderRadius: BorderRadius.circular(30.r),
                          label: "Save Ride",
                          isLoading: false,
                          onTap: () async {
                            userapicontroller.userAddtoSave();
                            // Get.toNamed(kUserDashboard);
                            //  KOtpVerification
                            //  await Get.toNamed(kOtpVerify);
                          }),
                    ],
                  )
                // Text(
                //     "Review Screen",
                //     style: TextStyle(
                //         fontSize: kSixteenFont,
                //         color: Kpink,
                //         fontWeight: kFW500),
                //   )
                : userapicontroller.listenOrders["message"] ==
                        "Your Order still Pending...!"
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                  margin: EdgeInsets.only(top: 35.h),
                                  width: 150.w,
                                  height: 42,
                                  fontSize: kFourteenFont,
                                  fontWeight: kFW700,
                                  textColor: Kwhite,
                                  borderRadius: BorderRadius.circular(30.r),
                                  label: "Re Order",
                                  isLoading: false,
                                  onTap: () async {
                                    var payload = {
                                      "orderPlaceTime": formattedTime,
                                      "orderPlaceDate": formattedDate
                                    };

                                    // {"mobile": _phoneController.text};
                                    userapicontroller.userReorder(payload);
                                    // Get.toNamed(kUserDashboard);
                                    //  KOtpVerification
                                    //  await Get.toNamed(kOtpVerify);
                                  }),
                              CustomButton(
                                  margin: EdgeInsets.only(top: 35.h),
                                  width: 150.w,
                                  height: 42,
                                  fontSize: kFourteenFont,
                                  fontWeight: kFW700,
                                  textColor: Kwhite,
                                  borderRadius: BorderRadius.circular(30.r),
                                  label: "Re Load",
                                  isLoading: false,
                                  onTap: () async {
                                    userapicontroller.listenUserOrders();
                                    // Get.toNamed(kUserDashboard);
                                    //  KOtpVerification
                                    //  await Get.toNamed(kOtpVerify);
                                  }),
                            ],
                          ),
                        ],
                      )

                    //    "message": "Your Order still Pending...!"
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Captain on the way",
                                style: TextStyle(
                                    fontSize: kSixteenFont,
                                    color: Kpink,
                                    fontWeight: kFW500),
                              ),
                              CustomButton(
                                  width: 80.w,
                                  height: 32.h,
                                  fontSize: kFourteenFont,
                                  fontWeight: kFW700,
                                  textColor: Kwhite,
                                  borderRadius: BorderRadius.circular(30.r),
                                  label: "3 min",
                                  isLoading: false,
                                  onTap: () async {}),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Divider(),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Start your order with PIN",
                                style: TextStyle(
                                    fontSize: kFourteenFont,
                                    color: Ktextcolor,
                                    fontWeight: kFW400),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10.w),
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
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          fontSize: kFourteenFont,
                                          color: kcarden,
                                          fontWeight: kFW400),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10.w),
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
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          fontSize: kFourteenFont,
                                          color: kcarden,
                                          fontWeight: kFW400),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10.w),
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
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          fontSize: kFourteenFont,
                                          color: kcarden,
                                          fontWeight: kFW400),
                                    ),
                                  ),
                                  Container(
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
                                    child: Text(
                                      "4",
                                      style: TextStyle(
                                          fontSize: kFourteenFont,
                                          color: kcarden,
                                          fontWeight: kFW400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "AP 21 BK0221",
                                    style: TextStyle(
                                        fontSize: kSixteenFont,
                                        color: kcarden,
                                        fontWeight: kFW500),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Text(
                                    userapicontroller
                                            .listenOrders["acceptCaptain"]
                                        ["mobile"],
                                    style: TextStyle(
                                        fontSize: kTwelveFont,
                                        color: Ktextcolor,
                                        fontWeight: kFW500),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    userapicontroller
                                        .listenOrders["acceptCaptain"]["name"],
                                    style: TextStyle(
                                        fontSize: kTwelveFont,
                                        color: KlightText,
                                        fontWeight: kFW500), // KlightText
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: Kwhite,
                                radius: 35.r,
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
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Kpink.withOpacity(
                                  0.5,
                                ),
                                size: 18.sp,
                              ),
                              SizedBox(
                                width: 35.w,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.message,
                                    color: Kpink.withOpacity(
                                      0.5,
                                    ),
                                    size: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    "Message Sandeep",
                                    style: TextStyle(
                                        fontSize: kTwelveFont,
                                        color: Ktextcolor,
                                        fontWeight: kFW500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pick up from",
                                style: TextStyle(
                                    fontSize: kTwelveFont,
                                    color: Ktextcolor,
                                    fontWeight: kFW500),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                "JNTU METRO STATION LIFT",
                                style: TextStyle(
                                    fontSize: kTwelveFont,
                                    color: KlightText,
                                    fontWeight: kFW500), // KlightText
                              ),
                            ],
                          ),
                          CustomButton(
                              margin: EdgeInsets.only(top: 35.h),
                              width: double.infinity,
                              height: 42.h,
                              fontSize: kFourteenFont,
                              fontWeight: kFW700,
                              textColor: Kwhite,
                              borderRadius: BorderRadius.circular(30.r),
                              label: "Cancel Raid",
                              isLoading: false,
                              onTap: () async {
                                var payload = {"Reason": "Long pick up"};

                                // {"mobile": _phoneController.text};
                                userapicontroller.userCancelRaid(payload);
                                // Get.toNamed(kUserDashboard);
                                //  KOtpVerification
                                //  await Get.toNamed(kOtpVerify);
                              }),
                          CustomButton(
                              margin: EdgeInsets.only(top: 35.h),
                              width: 150.w,
                              height: 42,
                              fontSize: kFourteenFont,
                              fontWeight: kFW700,
                              textColor: Kwhite,
                              borderRadius: BorderRadius.circular(30.r),
                              label: "Re Load",
                              isLoading: false,
                              onTap: () async {
                                userapicontroller.listenUserOrders();
                                // Get.toNamed(kUserDashboard);
                                //  KOtpVerification
                                //  await Get.toNamed(kOtpVerify);
                              }),
                        ],
                      )),
          );
        },
      ),
   
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////

  String getDurationAndDistance() {
    return '${getFormattedDistance(route!.distance!.floor())}(${getFormattedDuration(route!.duration!.floor())})';
  }

  String getFormattedDuration(int duration) {
    int min = (duration % 3600 / 60).floor();
    int hours = (duration % 86400 / 3600).floor();
    int days = (duration / 86400).floor();
    if (days > 0) {
      return '$days ${(days > 1 ? "Days" : "Day")} $hours hr ${(min > 0 ? "$min min" : "")}';
    } else {
      return (hours > 0
          ? '$hours hr ${(min > 0 ? "$min min" : "")}'
          : '$min min');
    }
  }

  String getFormattedDistance(int distance) {
    if ((distance / 1000) < 1) {
      return '$distance mtr.';
    }
    return '${(distance / 1000).toStringAsFixed(2)} Km.';
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  callDirection() async {
    await addImageFromAsset("icon", "assets/images/location.png");

    controller.clearSymbols();
    controller.clearLines();
    setState(() {
      route = null;
    });
    try {
      DirectionResponse? directionResponse = await MapplsDirection(
              origin: LatLng(
                  apicontroller.searchedData["waypoints"][0]["location"][0],
                  apicontroller.searchedData["waypoints"][0]["location"][1]),
              destination: LatLng(
                  apicontroller.searchedData["waypoints"][1]["location"][0],
                  apicontroller.searchedData["waypoints"][1]["location"][1]),
              alternatives: false,
              steps: true,
              resource: selectedResource.value,
              profile: profile[selectedIndex])
          .callDirection();
      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.isNotEmpty) {
        setState(() {
          route = directionResponse.routes![0];
        });
        Polyline polyline = Polyline.decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<LatLng> latlngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latlngList.add(LatLng(element[0], element[1]));
          });
        }
        if (directionResponse.waypoints != null) {
          List<SymbolOptions> symbols = [];
          directionResponse.waypoints?.forEach((element) {
            symbols.add(
              SymbolOptions(geometry: element.location, iconImage: 'icon'),
            );
          });
          controller.addSymbols(symbols);
        }
        drawPath(latlngList);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
    }
  }

  void drawPath(List<LatLng> latlngList) {
    controller.addLine(LineOptions(
      geometry: latlngList,
      lineColor: "#FF04C8",
      lineWidth: 4,
    ));
    LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,
        top: 100, bottom: 20, left: 10, right: 10));
  }

  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
  /////////////////////////////////////////////////////////////////////////////////
}

// class ResourceList {
//   final String value;
//   final String text;

//   ResourceList(this.value, this.text);
// }

class StarRating extends StatelessWidget {
  final int rating;
  final int starCount;
  final Function(int) onRatingChanged;

  StarRating({
    required this.rating,
    this.starCount = 5,
    required this.onRatingChanged,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index < rating) {
      icon = Icon(
        Icons.star,
        color: Colors.amber,
      );
    } else {
      icon = Icon(
        Icons.star_border,
        color: Colors.grey,
      );
    }
    return InkResponse(
      onTap: () => onRatingChanged(index + 1),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) => buildStar(context, index)),
    );
  }
}
