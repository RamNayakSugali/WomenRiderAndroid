import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:womentaxi/untils/export_file.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiController apicontroller = Get.put(ApiController());
  bool _switchValue = false;
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  final LocalAuthentication auth = LocalAuthentication();

  SupportState supportState = SupportState.unknown;

  List<BiometricType>? availableBiometrics;

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
  }

  ///
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

  ////////////
  @override
  void initState() {
    if (serviceController.address.value == "" &&
        serviceController.position == null) {
      _getCurrentLocation();
    } else if (!isPermissionGiven) {
      _getCurrentLocation();
    }
    setState(() {
      if (apicontroller.profileData["onDuty"] == true) {
        apicontroller.switchedValue.value = true;
        // _switchValue = true
        apicontroller.duty.value = "ON DUTY";
      }

      apicontroller.getBannersOne();

      //performAction();
      // apiController.storedloginsData.value =
      //     jsonDecode(UserSimplePreferences.getUserdata().toString());
      // UserSimplePreferences.getUserdata();
    });
    ///////////auth///////////////////////////
    auth.isDeviceSupported().then((bool isSupported) => setState(() =>
        supportState =
            isSupported ? SupportState.supported : SupportState.unSupported));
    ///////////////////////////////////////////////////////////////////////////
    // print(apiController.storedloginsData);
    // apiController.storedloginsData = jsonDecode(UserSimplePreferences.getUserdata().toString());
    super.initState();
    checkBiometric();

    getAvailableBiometrics();

    // authenticateWithBiometrics();
  }

  Future<void> checkBiometric() async {
    late bool canCheckBiometric;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;

      print("Biometric supported: $canCheckBiometric");
    } on PlatformException catch (e) {
      print(e);

      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> biometricTypes;

    try {
      biometricTypes = await auth.getAvailableBiometrics();

      print("supported biometrics $biometricTypes");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      availableBiometrics = biometricTypes;
    });
  }

  Future<void> authenticateWithBiometrics(bool value) async {
    try {
      final authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint or Face ID',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));

      if (!mounted) {
        return;
      }

      if (authenticated) {
        Get.toNamed(kFacialBiometric);

        // apicontroller.captainAvailability();
        // setState(() {
        //   _switchValue = value;
        //   apicontroller.duty == "ON DUTY"
        //       ? apicontroller.duty.value = "OFF DUTY"
        //       : apicontroller.duty.value = "ON DUTY";
        // });
        // Get.toNamed(KSplash);

        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } on PlatformException catch (e) {
      print(e);

      return;
    }
  }

  // /
  //////////////////////////////////////////////////////////////////////Mappls maps
  Position? _currentPosition;
  String _currentAddress = "";
  ////////////////////////////////
  ServiceController serviceController = Get.put(ServiceController());

  double lat = 37.42796133580664;
  double lon = -122.085749655962;

  // String? _currentAddress;

  var isLoading = "none";
  void _getCurrentLocation() async {
    setState(() {
      isLoading = "started";
      if (serviceController.address.value == "" &&
          serviceController.position == null) {
        _getCurrentLocation();
      } else if (!isPermissionGiven) {
        _getCurrentLocation();
      }
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

  // @override
  // void initState() {
  //   if (serviceController.address.value == "" &&
  //       serviceController.position == null) {
  //     _getCurrentLocation();
  //   } else if (!isPermissionGiven) {
  //     _getCurrentLocation();
  //   }
  //   // _getCurrentLocation();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd-MM-yyyy").format(now);
    String formattedTime = DateFormat("hh:mm a").format(now);
    setState(() {
      apicontroller.today.value = formattedDate;
      print(apicontroller.today);
    });
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
                  Get.toNamed(KProfile);
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
                title: new Text('Earnings'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(KEarningsScreen);
                },
              ),
              new ListTile(
                title: new Text('Orders'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kAcceptOrders);
                },
              ),
              ListTile(
                title: new Text('Completed orderd'),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Kpink.withOpacity(
                    0.5,
                  ),
                  size: 24.sp,
                ),
                onTap: () {
                  Get.toNamed(kCompletedOrdersScreen);
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
        appBar: AppBar(
          backgroundColor: Kwhite,
          automaticallyImplyLeading: false,
          elevation: 1.5.sp,

          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
          // InkWell(
          //     onTap: () => Scaffold.of(context).openDrawer(),
          //     child: Icon(Icons.more_vert)),
          centerTitle: true,
          title: Obx(() => Container(
                width: 150.w,
                padding: EdgeInsets.only(left: 5.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                        color: apicontroller.duty == "ON DUTY"
                            ? Kpink.withOpacity(0.5)
                            : kcarden.withOpacity(0.5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${apicontroller.duty}",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: kFW500,
                          color: apicontroller.duty == "ON DUTY"
                              ? Kpink.withOpacity(0.5)
                              : kcarden.withOpacity(0.5)),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Transform.scale(
                        scale: 0.7,
                        child: Obx(
                          () => Switch(
                            onChanged: (value) {
                              setState(() {
                                apicontroller.switchedValueOrg.value = value;
                                // switchedValue
                              });
                              authenticateWithBiometrics(value);
                              // apicontroller.captainAvailability();
                              // setState(() {
                              //   _switchValue = value;
                              //   apicontroller.duty == "ON DUTY"
                              //       ? apicontroller.duty.value = "OFF DUTY"
                              //       : apicontroller.duty.value = "ON DUTY";
                              // });
                            },
                            value: apicontroller.switchedValue.value,
                            // value: _switchValue,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: Kpink,
                            activeTrackColor: Kpink.withOpacity(0.5),
                            inactiveThumbColor: KText,
                            inactiveTrackColor: KText.withOpacity(0.5),
                          ),
                        ))
                  ],
                ),
              )),
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(KNotifications);
              },
              child: Icon(
                Icons.notifications,
                color: kcarden,
                size: 24.sp,
              ),
            ),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              EarningsData(),
              Obx(
                () => apicontroller.duty == "ON DUTY"
                    ? Container(
                        // height: 500.h,
                        height: MediaQuery.of(context).size.height / 1.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Kwhite,
                        ),
                        child: ClipRRect(
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
                            ))
                    : OffdutyCard(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
