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

class UserBookRide extends StatefulWidget {
  const UserBookRide({super.key});

  @override
  State<UserBookRide> createState() => _UserBookRideState();
}

class _UserBookRideState extends State<UserBookRide> {
  ApiController apicontroller = Get.put(ApiController());
  UserApiController userapicontroller = Get.put(UserApiController());
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );

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

  @override
  void initState() {
    super.initState();
    setState(() {
      apicontroller.selectedVehicle.value = "scooty";
      selectedResource = resource[0];
    });
    _getAddressFromLatLng();
    _getDropAddressFromLatLng();
  }

  ///////////////////////////////////////////Get Address from Lat and Longitude
  String? _currentAddress;
  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(
            apicontroller.searchedData["waypoints"][0]["location"][0],
            apicontroller.searchedData["waypoints"][0]["location"][1]
            // serviceController.position!.latitude,
            //       serviceController.position!.longitude
            )
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea},${place.postalCode}';
        apicontroller.searchedDataPickupAddress.value =
            _currentAddress.toString();
        print(apicontroller.searchedDataPickupAddress.value);
        // serviceController.addressLatitude.value =
        //     serviceController.position!.latitude.toString();
        // serviceController.addressLongitude.value =
        //     serviceController.position!.longitude.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Drop Address
  String? _dropAddress;
  Future<void> _getDropAddressFromLatLng() async {
    await placemarkFromCoordinates(
            apicontroller.searchedData["waypoints"][1]["location"][0],
            apicontroller.searchedData["waypoints"][1]["location"][1]
            // serviceController.position!.latitude,
            //       serviceController.position!.longitude
            )
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _dropAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea},${place.postalCode}';
        apicontroller.searchedDataDropAddress.value = _dropAddress.toString();
        print(apicontroller.searchedDataDropAddress.value);
        // serviceController.addressLatitude.value =
        //     serviceController.position!.latitude.toString();
        // serviceController.addressLongitude.value =
        //     serviceController.position!.longitude.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd-MM-yyyy").format(now);
    String formattedTime = DateFormat("hh:mm a").format(now);
    //////////////////////////////////////////
    return Scaffold(
      backgroundColor: Kwhite,
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      // 1
                      onTap: () {
                        setState(() {
                          apicontroller.selectedVehicle.value = "scooty";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: apicontroller.selectedVehicle == "scooty"
                                  ? Kpink
                                  : Kwhite),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/scooty.png",
                                    width: 60.w,
                                    height: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Scooty",
                                  style: TextStyle(
                                      fontSize: kSixteenFont,
                                      color: kcarden,
                                      fontWeight: kFW500),
                                ),
                              ],
                            ),
                            Text(
                              "₹ 49",
                              style: TextStyle(
                                  fontSize: kSixteenFont,
                                  color: kcarden,
                                  fontWeight: kFW500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      // 2
                      onTap: () {
                        setState(() {
                          apicontroller.selectedVehicle.value = "cab";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: apicontroller.selectedVehicle == "cab"
                                  ? Kpink
                                  : Kwhite),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/cabed.png",
                                    width: 60.w,
                                    height: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Cab",
                                  style: TextStyle(
                                      fontSize: kSixteenFont,
                                      color: kcarden,
                                      fontWeight: kFW500),
                                ),
                              ],
                            ),
                            Text(
                              "₹ 49",
                              style: TextStyle(
                                  fontSize: kSixteenFont,
                                  color: kcarden,
                                  fontWeight: kFW500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      // 3
                      onTap: () {
                        setState(() {
                          apicontroller.selectedVehicle.value = "auto";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: apicontroller.selectedVehicle == "auto"
                                  ? Kpink
                                  : Kwhite),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/autoed.png",
                                    width: 60.w,
                                    height: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "Auto",
                                  style: TextStyle(
                                      fontSize: kSixteenFont,
                                      color: kcarden,
                                      fontWeight: kFW500),
                                ),
                              ],
                            ),
                            Text(
                              "₹ 49",
                              style: TextStyle(
                                  fontSize: kSixteenFont,
                                  color: kcarden,
                                  fontWeight: kFW500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      // 4
                      onTap: () {
                        setState(() {
                          apicontroller.selectedVehicle.value = "parcel";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: apicontroller.selectedVehicle == "parcel"
                                  ? Kpink
                                  : Kwhite),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    "assets/images/parcelbike.png",
                                    width: 70.w,
                                    height: 45.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  "Parcel",
                                  style: TextStyle(
                                      fontSize: kSixteenFont,
                                      color: kcarden,
                                      fontWeight: kFW500),
                                ),
                              ],
                            ),
                            Text(
                              "₹ 49",
                              style: TextStyle(
                                  fontSize: kSixteenFont,
                                  color: kcarden,
                                  fontWeight: kFW500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
                        margin: EdgeInsets.only(top: 40.h),
                        width: double.infinity,
                        height: 42.h,
                        fontSize: kFourteenFont,
                        fontWeight: kFW700,
                        textColor: Kwhite,
                        borderRadius: BorderRadius.circular(30.r),
                        label: "Book Ride",
                        isLoading: false,
                        onTap: () {
                          var payload = {
                            //  "dropLatitude": "17.413973667114202",
                            // "dropLongitude": "78.37360815684931",
                            // "pickupLatitude": "17.419151642685726",
                            // "pickupLongitude": "78.3889548353466",

                            "dropLangitude":
                                "${apicontroller.searchedData["waypoints"][1]["location"][0]}",
                            "dropLongitude":
                                "${apicontroller.searchedData["waypoints"][1]["location"][1]}",
                            "pickupLangitude":
                                "${apicontroller.searchedData["waypoints"][0]["location"][0]}",
                            "pickupLongitude":
                                "${apicontroller.searchedData["waypoints"][0]["location"][1]}",
                            "pickupAddress":
                                apicontroller.searchedDataPickupAddress.value,
                            "dropAddress":
                                apicontroller.searchedDataDropAddress.value,
                            "price": "250",
                            "orderPlaceTime": formattedTime,
                            "orderPlaceDate": formattedDate,
                            "vehicleType": apicontroller.selectedVehicle.value
                          };
                          userapicontroller.placeOrdersUser(payload);
                          // Get.toNamed(kUserRaidOtp);
                        }),
                  ],
                ),
              ));
        },
      ),
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
}

class ResourceList {
  final String value;
  final String text;

  ResourceList(this.value, this.text);
}
