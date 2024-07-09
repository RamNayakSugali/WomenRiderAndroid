import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:womentaxi/untils/export_file.dart';
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:womentaxi/untils/export_file.dart';
import 'package:geolocator/geolocator.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  // UserApiController
  UserApiController userapicontroller = Get.put(UserApiController());
  bool _switchValue = false;
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) async {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
    // UserSimplePreferences().setMapShowSTatuc(isSwitched);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(
                  fontSize: kEighteenFont,
                  fontWeight: kFW600,
                  color: Ktextcolor),
            ),
            content: Text(
              'Do you want to exit this App',
              style:
                  TextStyle(fontSize: 13.sp, fontWeight: kFW600, color: KText),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(
                      fontSize: kTwelveFont,
                      fontWeight: kFW600,
                      color: kcarden),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                // <-- SEE HERE
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: kTwelveFont, fontWeight: kFW600, color: Kpink),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  /////////////////////////////////////////////////////////
  ServiceController serviceController = Get.put(ServiceController());
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  double lat = 37.42796133580664;
  double lon = -122.085749655962;

  String? _currentAddress;

  var isLoading = "none";
  void _getCurrentLocation() async {
    setState(() {
      isLoading = "started";
    });
    Position? position = await _determinePosition();
    setState(() {
      serviceController.position = position;
      serviceController.latittude = serviceController.position!.latitude;
      serviceController.longitude = serviceController.position!.longitude;
      _getAddressFromLatLng(position!);
    });
  }

  Future<Position?> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      } else {
        await _showMyDialog();
        if (isPermissionGiven == true) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        } else {
          Fluttertoast.showToast(
            msg: "Denined Location Will Failed To Upload Attendance",
          );
        }
      }
    } else {
      setState(() {
        isPermissionGiven = true;
      });
    }
    Position? positionData;
    try {
      positionData = await Geolocator.getCurrentPosition();
      serviceController.loacationIsEnabled(true);
      debugPrint(positionData.toString());
    } catch (e) {
      debugPrint("$e");
      serviceController.loacationIsEnabled(false);
    }
    setState(() {
      isLoading = "ended";
    });
    return positionData;
  }

  bool isPermissionGiven = false;
  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 350.h,
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text('Location Permission',
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: 14.sp,
                          fontWeight: kFW900)),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                      'Woman Taxi wants collects Your Location Info to display',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: kTenFont,
                          fontWeight: kFW500)),
                  SizedBox(
                    height: 15.h,
                  ),
                  Image.asset(
                    "assets/images/location.png",
                    width: 150.w,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Custom_OutlineButton(
                          borderRadius: BorderRadius.circular(15.r),
                          margin: EdgeInsets.all(10.r),
                          width: 110.w,
                          height: 35.h,
                          Color: Kpink,
                          textColor: Kpink,
                          fontSize: 12.sp,
                          fontWeight: kFW700,
                          label: "Cancel",
                          isLoading: false,
                          onTap: () {
                            setState(() {
                              isPermissionGiven = false;
                            });
                            Navigator.of(context).pop();
                          }),
                      CustomButton(
                          borderRadius: BorderRadius.circular(15.r),
                          margin: EdgeInsets.all(10.r),
                          width: 110.w,
                          height: 35.h,
                          Color: Kpink,
                          textColor: Kwhite,
                          fontSize: 12.sp,
                          fontWeight: kFW700,
                          label: "Accept",
                          isLoading: false,
                          onTap: () {
                            setState(() {
                              isPermissionGiven = true;
                            });
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(serviceController.position!.latitude,
            serviceController.position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea},${place.postalCode}';
        serviceController.address.value = _currentAddress.toString();
        serviceController.addressLatitude.value =
            serviceController.position!.latitude.toString();
        serviceController.addressLongitude.value =
            serviceController.position!.longitude.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    if (serviceController.address.value == "" &&
        serviceController.position == null) {
      _getCurrentLocation();
    } else if (!isPermissionGiven) {
      _getCurrentLocation();
    }
    userapiController.getUserSavedOrders();
    // _getCurrentLocation();
    super.initState();
  }
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Kwhite,
        drawer: new Drawer(
          child: new ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              SizedBox(
                height: 60.h,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(kUserProfile);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                    ),
                    CircleAvatar(
                        backgroundColor: Ktextcolor.withOpacity(0.5),
                        child: Icon(Icons.person)),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: kEighteenFont,
                          fontWeight: kFW400,
                          color: kcarden),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 26.sp,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              new ListTile(
                title: new Text('Notifications'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserNotifications);
                },
              ),
              ListTile(
                title: new Text('Rides History'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserRideHistory);
                },
              ),
              //  kUserRideHistory
              ListTile(
                title: new Text('User Payments'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserPayments);
                },
              ),
              ListTile(
                title: new Text('User Parcel'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserParcel);
                },
              ),
              ListTile(
                title: new Text('Restaurants'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserRestaurantList);
                },
              ),
              ListTile(
                title: new Text('Cart'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserCart);
                },
              ),
              ListTile(
                title: new Text('kUserOrdersHistory'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kUserOrdersHistory);
                },
              ),
              ListTile(
                title: new Text('Log Out'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kSelectType);
                },
              ),
            ],
          ),
        ),
        drawerEnableOpenDragGesture: false,
        body: SlidingSheet(
          elevation: 8,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.4, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                    // height: 500.h,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Kwhite,
                    ),
                    child:
                        //////////////////////////////////////////////////////////////////////
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r)),
                            child: isLoading == "ended"
                                ? Obx(
                                    () => isPermissionGiven == true &&
                                            serviceController
                                                    .loacationIsEnabled.value !=
                                                false
                                        ? serviceController.position != null &&
                                                serviceController
                                                        .loacationIsEnabled
                                                        .value !=
                                                    false
                                            ? Expanded(
                                                child: MapplsMap(
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: LatLng(
                                                        serviceController
                                                            .position!.latitude,
                                                        serviceController
                                                            .position!
                                                            .longitude),
                                                    zoom: 14.0,
                                                  ),
                                                  myLocationEnabled: true,
                                                  myLocationRenderMode:
                                                      MyLocationRenderMode.GPS,
                                                  onMapCreated:
                                                      (MapplsMapController
                                                          controller) {
                                                    controller.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                        LatLng(
                                                            serviceController
                                                                .position!
                                                                .latitude,
                                                            serviceController
                                                                .position!
                                                                .longitude),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                // Google_map()
                                              )

                                            // GoogleMap(
                                            //     myLocationButtonEnabled: true,
                                            //     myLocationEnabled: true,
                                            //     zoomControlsEnabled: true,
                                            //     scrollGesturesEnabled: true,
                                            //     mapType: MapType.normal,
                                            //     // initialCameraPosition: CameraPosition(
                                            //     //   target: LatLng( serviceController.position!.latitude,
                                            //     //       serviceController.position!.longitude),
                                            //     //   zoom: 15.0000,
                                            //     // ),
                                            //     onMapCreated: (GoogleMapController controller) {
                                            //       _controller.complete(controller);
                                            //     }, initialCameraPosition:  (){},
                                            //   )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Kgreen,
                                                ),
                                              )
                                        : Image.asset(
                                            "assets/images/nolocation.png",
                                            fit: BoxFit.contain,
                                          ),
                                  )
                                : Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/locationBanner.png",
                                        fit: BoxFit.contain,
                                      ),
                                      Container(
                                        width: 150.w,
                                        // alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 15.h, top: 20.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Text("Location ",
                                                style: TextStyle(
                                                  color: Kpink,
                                                  fontSize: 25.sp,
                                                  fontWeight: kFW900,
                                                )),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            Text("Loading...",
                                                style: TextStyle(
                                                    color: kcarden,
                                                    fontSize: 15.sp,
                                                    fontWeight: kFW900)),
                                            AnimatedTextKit(animatedTexts: [
                                              TyperAnimatedText(
                                                  "Please Wait Untill It Loads...",
                                                  textStyle: TextStyle(
                                                    color: kcarden,
                                                    fontSize: 10.sp,
                                                    fontWeight: kFW900,
                                                  ))
                                            ]),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                            // serviceController.address.value == null
                            //     ? Center(child: CircularProgressIndicator())
                            //     :
                            //     Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: <Widget>[
                            //             SizedBox(height: 20),
                            //             Expanded(
                            //               child: MapplsMap(
                            //                 initialCameraPosition: CameraPosition(
                            //                   target: LatLng(
                            //                       serviceController
                            //                           .position!.latitude,
                            //                       serviceController
                            //                           .position!.longitude),
                            //                   zoom: 14.0,
                            //                 ),
                            //                 myLocationEnabled: true,
                            //                 myLocationRenderMode:
                            //                     MyLocationRenderMode.GPS,
                            //                 onMapCreated:
                            //                     (MapplsMapController controller) {
                            //                   controller.animateCamera(
                            //                     CameraUpdate.newLatLng(
                            //                       LatLng(
                            //                           serviceController
                            //                               .position!.latitude,
                            //                           serviceController
                            //                               .position!.longitude),
                            //                     ),
                            //                   );
                            //                 },
                            //               ),

                            //               // Google_map()
                            //             ),
                            //           ])
                            )

                    ////////////////////////////////
                    // ClipRRect(
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(8.r),
                    //         topRight: Radius.circular(8.r)),
                    //     child:

                    //     //  const Google_map()
                    //      ),
                    ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => Container(
                        margin: EdgeInsets.only(top: 60.h, left: 20.w),
                        child: CircleAvatar(
                          backgroundColor: Kwhite,
                          radius: 20.r,
                          child: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer()),
                        ),
                      ),
                    ),
                    Container(
                      //  height: 60.h,
                      margin: EdgeInsets.only(top: 60.h, left: 5.w),
                      width: 200.w,
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
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: KBlue,
                            radius: 5.r,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              var payload = {
                                //  "dropLatitude": "17.413973667114202",
                                // "dropLongitude": "78.37360815684931",
                                // "pickupLatitude": "17.419151642685726",
                                // "pickupLongitude": "78.3889548353466",

                                "dropLangitude": "17.413973667114202",
                                "dropLongitude": "78.37360815684931",
                                "pickupLangitude": "17.419151642685726",
                                "pickupLongitude": "78.3889548353466",
                                "pickupAddress": "Raidurg",
                                "dropAddress": "Sutherland",
                                "price": "250",
                                "orderPlaceTime": "08:09 AM",
                                "orderPlaceDate": "03/07/2024",
                                "vehicleType": "bike"
                              };
                              userapicontroller.placeOrdersUser(payload);

                              // "locations": authentication
                              //     .registerDonorAddressController
                              //     .text,
                              // "longitude":
                              //     "${serviceController.position!.longitude}",
                              // "latitude":
                              //     "${serviceController.position!.latitude}",
                              // "signupTime": DateFormat('dd-MM-yyyy')
                              //     .format(DateTime.now()),
                              // "termAndCondition": value

                              ////////////////////////////////////////////////////////////////////////////////////////////////
                              // {

                              //   "locations" : "Bhimavaram West Godavari",
                              //   "longitude" : 78.4089828,
                              //   "latitude" :17.4851206,
                              //   "signupTime" : "28/05/2024",
                              //   "termAndCondition" : true
                              // }
                              ///////////////////////////
                              // {
                              //   "firstName": authentication
                              //       .registerDonorfirstNameController
                              //       .text,
                              //   //"Ram Nayak",
                              //   "lastName": authentication
                              //       .registerDonorlastNameController
                              //       .text,
                              //   //"Sugali",
                              //   "mobile": authentication
                              //       .enteredNumber.value,
                              //   // "mobile": authentication.registerDonorMobileController.text,
                              //   //"9989779695",
                              //   "email": authentication
                              //       .registerDonorEmailController
                              //       .text,
                              //   //"vamsidigamarthi09039j9@gmail.com",
                              //   "bloodGroup": authentication
                              //       .donorRegisterBloodGroup.value,
                              //   "gender": authentication
                              //       .donorRegisterGender.value,
                              //   // selectedGenderValue
                              //   //   authentication.registerDonorBloodController.text,
                              //   //"B+",
                              //   "dateOfBirth": selectDate.value,
                              //   // authentication
                              //   //     .registerDonorDateofBirthController.text,
                              //   //"08/05/1999",
                              //   "location": authentication
                              //       .registerDonorAddressController
                              //       .text,

                              //   //"${serviceController.address.value}",
                              //   //"Palakollu",
                              //   "longitude":
                              //       "${serviceController.position!.latitude}",
                              //   //81.6497616,
                              //   "latitude":
                              //       "${serviceController.position!.longitude}"
                              //   //16.5196953
                              // };

                              // "phone": authentication.loginMobileController.text,
                              //  "8297297247"
                            },
                            // onTap: () {},
                            child: Text(
                              "Your Current Location",
                              style: TextStyle(
                                  fontSize: kFourteenFont,
                                  color: KdarkText,
                                  fontWeight: kFW500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.all(15.r),
              color: Kwhite,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    ontap: () {
                      Get.toNamed(kMergeMapplsScreen);
                      //   Get.toNamed(kUserSelectDrop);
                    },
                    enabled: true,
                    prefix: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 5),
                        child: Icon(
                          Icons.search,
                          color: kcarden,
                        )),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    fontSize: kFourteenFont,
                    fontWeight: FontWeight.w500,
                    hintText: "Where are you going",
                    maxLines: 1,
                    readOnly: false,
                    label: "",
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  // ramsaved
                  Obx(() => userapiController.userSavedOrdersDataLoading == true
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 100.h),
                          child: CircularProgressIndicator(
                            color: Kpink,
                          ),
                        )
                      : userapiController.userSavedOrders.isEmpty ||
                              userapiController.userSavedOrders == null
                          ? Text(
                              "",
                              style: GoogleFonts.roboto(
                                  fontSize: kSixteenFont,
                                  color: KdarkText,
                                  fontWeight: kFW500),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  userapiController.userSavedOrders.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 12.h),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_searching,
                                        color: Kpink.withOpacity(
                                          0.5,
                                        ),
                                        size: 18.sp,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 150.w,
                                            child: Text(
                                              userapiController.userSavedOrders[
                                                      index]["dropAddress"] ??
                                                  "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kSixteenFont,
                                                  color: kcarden,
                                                  fontWeight: kFW500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          SizedBox(
                                            width: 200.w,
                                            child: Text(
                                              userapiController.userSavedOrders[
                                                      index]["pickupAddress"] ??
                                                  "",
                                              //     "Survey No. 1050, Balanagar Mandal, Rd Number 3, Kukatpally Housing Board Colony, Kukatpally, Hyderabad, Telangana 500072",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  color: Ktextcolor,
                                                  fontWeight: kFW500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // userAddtoFavourite
                                      userapiController.userSavedOrders[index]
                                                  ["favorite"] ==
                                              false
                                          ? InkWell(
                                              onTap: () {
                                                userapicontroller
                                                    .userAddtoFavourite(
                                                        userapiController
                                                                .userSavedOrders[
                                                            index]["_id"]);
                                              },
                                              child: Icon(
                                                Icons.favorite_outline,
                                                color: KlightText,
                                                //  Kpink.withOpacity(
                                                //   0.5,

                                                size: 18.sp,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                userapicontroller
                                                    .userAddtoFavourite(
                                                        userapiController
                                                                .userSavedOrders[
                                                            index]["_id"]);
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                color: Kpink,
                                                //  Kpink.withOpacity(
                                                //   0.5,

                                                size: 18.sp,
                                              ),
                                            )
                                    ],
                                  ),
                                );
                              })),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "Explore",
                    style: TextStyle(
                        fontSize: kSixteenFont,
                        color: kcarden,
                        fontWeight: kFW500),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/bikeTaxi.jpg",
                              width: 60.w,
                              height: 60.h,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Bike",
                            style: TextStyle(
                                fontSize: kSixteenFont,
                                color: kcarden,
                                fontWeight: kFW500),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/bikeTaxi.jpg",
                              width: 60.w,
                              height: 60.h,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Bike Lite",
                            style: TextStyle(
                                fontSize: kSixteenFont,
                                color: kcarden,
                                fontWeight: kFW500),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/autoTaxi.jpg",
                              width: 60.w,
                              height: 60.h,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
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
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/autoShare.jpg",
                              width: 60.w,
                              height: 60.h,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Auto Share",
                            style: TextStyle(
                                fontSize: kSixteenFont,
                                color: kcarden,
                                fontWeight: kFW500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
