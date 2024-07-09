import 'package:womentaxi/untils/export_file.dart';
import 'package:flutter/foundation.dart';
import 'package:womentaxi/untils/export_file.dart';

class DropScreen extends StatefulWidget {
  const DropScreen({super.key});

  @override
  State<DropScreen> createState() => _DropScreenState();
}

class _DropScreenState extends State<DropScreen> {
  ApiController apiController = Get.put(ApiController());
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: kcarden,
            size: 20.sp,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          "Go to Drop zone",
          style: TextStyle(
              fontSize: kEighteenFont, fontWeight: kFW500, color: kcarden),
        ),
      ),
      body: SlidingSheet(
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
            child: Column(
              children: [
                Container(
                  width: double.infinity,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Ktextcolor,
                        radius: 15.r,
                        child: Icon(Icons.person),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apiController.acceptOrderData["head"]["name"] ??
                                "No Name",
                            style: TextStyle(
                                fontSize: kFourteenFont,
                                color: kcarden,
                                fontWeight: kFW500),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            width: 220.w,
                            child: Text(
                              apiController.acceptOrderData["dropAddress"] ??
                                  "No Address",

                              //    "325, High Tension Line Rd, Srinivas Colony, Aditya Nagar, Kukatpally, Hyderabad, Telangana 500072",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: kTwelveFont,
                                  color: Ktextcolor,
                                  fontWeight: kFW500),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          CustomButton(
                              width: 250.w,
                              height: 42.h,
                              fontSize: kFourteenFont,
                              fontWeight: kFW700,
                              textColor: Kwhite,
                              borderRadius: BorderRadius.circular(30.r),
                              label: "Start Ride",
                              isLoading: false,
                              onTap: () async {
                                //  KOtpVerification
                                //  await Get.toNamed(kOtpVerify);
                              }),
                          CustomButton(
                              margin: EdgeInsets.only(top: 35.h),
                              width: 250.w,
                              height: 42.h,
                              fontSize: kFourteenFont,
                              fontWeight: kFW700,
                              textColor: Kwhite,
                              borderRadius: BorderRadius.circular(30.r),
                              label: "Arrived",
                              isLoading: false,
                              onTap: () async {
                                Get.toNamed(kCollectAmount);
                                //  KOtpVerification ///
                                //  await Get.toNamed(kOtpVerify);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // Column(
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height / 1.5,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(10.r),
      //         color: Kwhite,
      //       ),
      //       child: ClipRRect(
      //           borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(8.r),
      //               topRight: Radius.circular(8.r)),
      //           child: const Google_map()),
      //     ),
      //     SizedBox(
      //       height: 12.h,
      //     ),
      //     Container(
      //       width: double.infinity,
      //       padding: EdgeInsets.all(10.r),
      //       decoration: BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //             color: Ktextcolor.withOpacity(0.5),
      //             blurRadius: 5.r,
      //             offset: Offset(1, 1),
      //             spreadRadius: 1.r,
      //           )
      //         ],
      //         color: Kwhite,
      //         borderRadius: BorderRadius.circular(10.r),
      //       ),
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           CircleAvatar(
      //             backgroundColor: Ktextcolor,
      //             radius: 15.r,
      //             child: Icon(Icons.person),
      //           ),
      //           SizedBox(
      //             width: 20.w,
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 "Sridhar Babu",
      //                 style: TextStyle(
      //                     fontSize: kFourteenFont,
      //                     color: kcarden,
      //                     fontWeight: kFW500),
      //               ),
      //               SizedBox(
      //                 height: 8.h,
      //               ),
      //               SizedBox(
      //                 width: 220.w,
      //                 child: Text(
      //                   "325, High Tension Line Rd, Srinivas Colony, Aditya Nagar, Kukatpally, Hyderabad, Telangana 500072",
      //                   maxLines: 2,
      //                   overflow: TextOverflow.ellipsis,
      //                   style: TextStyle(
      //                       fontSize: kTwelveFont,
      //                       color: Ktextcolor,
      //                       fontWeight: kFW500),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 15.h,
      //               ),
      //               CustomButton(
      //                   width: 250.w,
      //                   height: 42.h,
      //                   fontSize: kFourteenFont,
      //                   fontWeight: kFW700,
      //                   textColor: Kwhite,
      //                   borderRadius: BorderRadius.circular(30.r),
      //                   label: "Arrived",
      //                   isLoading: false,
      //                   onTap: () async {
      //                     Get.toNamed(kDropScreen);
      //                     //  KOtpVerification
      //                     //  await Get.toNamed(kOtpVerify);
      //                   }),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

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
                  apiController.acceptOrderData["pickup"]["coordinates"][1],
                  apiController.acceptOrderData["pickup"]["coordinates"][0]
                  // apicontroller.searchedData["waypoints"][0]["location"][0],
                  // apicontroller.searchedData["waypoints"][0]["location"][1]
                  ),
              destination: LatLng(
                  apiController.acceptOrderData["drop"]["coordinates"][1],
                  apiController.acceptOrderData["drop"]["coordinates"][0]
                  // apicontroller.searchedData["waypoints"][1]["location"][0],
                  // apicontroller.searchedData["waypoints"][1]["location"][1]
                  ),
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
}

// class DropScreen extends StatefulWidget {
//   const DropScreen({super.key});

//   @override
//   State<DropScreen> createState() => _DropScreenState();
// }

// class _DropScreenState extends State<DropScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: kcarden,
//             size: 20.sp,
//           ),
//         ),
//         titleSpacing: 0,
//         title: Text(
//           "Go to Drop zone",
//           style: TextStyle(
//               fontSize: kEighteenFont, fontWeight: kFW500, color: kcarden),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height / 1.5,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.r),
//               color: Kwhite,
//             ),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(8.r),
//                     topRight: Radius.circular(8.r)),
//                 child: const Google_map()),
//           ),
//           SizedBox(
//             height: 12.h,
//           ),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(10.r),
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Ktextcolor.withOpacity(0.5),
//                   blurRadius: 5.r,
//                   offset: Offset(1, 1),
//                   spreadRadius: 1.r,
//                 )
//               ],
//               color: Kwhite,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Ktextcolor,
//                   radius: 15.r,
//                   child: Icon(Icons.person),
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Sridhar Babu",
//                       style: TextStyle(
//                           fontSize: kFourteenFont,
//                           color: kcarden,
//                           fontWeight: kFW500),
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     SizedBox(
//                       width: 220.w,
//                       child: Text(
//                         "325, High Tension Line Rd, Srinivas Colony, Aditya Nagar, Kukatpally, Hyderabad, Telangana 500072",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: kTwelveFont,
//                             color: Ktextcolor,
//                             fontWeight: kFW500),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.h,
//                     ),
//                     CustomButton(
//                         width: 250.w,
//                         height: 42.h,
//                         fontSize: kFourteenFont,
//                         fontWeight: kFW700,
//                         textColor: Kwhite,
//                         borderRadius: BorderRadius.circular(30.r),
//                         label: "Drop",
//                         isLoading: false,
//                         onTap: () async {
//                           Get.toNamed(kCollectAmount);
//                           //  KOtpVerification
//                           //  await Get.toNamed(kOtpVerify);
//                         }),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
