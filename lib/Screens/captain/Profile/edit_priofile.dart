// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:womentaxi/untils/export_file.dart';
import 'package:intl/intl.dart';
//import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController dOBController = TextEditingController();
  ApiController apicontroller = Get.put(ApiController());
  final List<String> bloodgroupss = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime choosenDate = DateTime.now();
  var selectDate = "Select Date".obs;
  final List<String> genderlist = ['Male', 'Female', 'Other'];
  String startTime = "";
  String closeTime = "";
  /////////////////////////////////////////////////////////
  Future<TimeOfDay?> getTime({
    required BuildContext context,
    String? title,
    String? formattedTime,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Kwhite, // Background color
              hourMinuteTextColor:
                  kbloodred, // Text color for hours and minutes
              dayPeriodTextColor: KdarkText, // Text color for AM/PM
              dayPeriodBorderSide:
                  BorderSide(color: KdarkText), // Border color for AM/PM
              dialHandColor: kbloodred, // Color of the hour hand
              dialTextColor: Kwhite, // Text color on the clock dial
              dialBackgroundColor: kbloodred.withOpacity(0.5),
              //dayPeriodColor: lightBlue,
              //hourMinuteColor: lightBlue,
              entryModeIconColor: kbloodred,
              helpTextStyle: GoogleFonts.roboto(
                color: KText, // Set the text color for "Enter time"
              ),
              cancelButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown.shade300),
                  foregroundColor: MaterialStateProperty.all<Color>(kbloodred)),
              confirmButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown.shade300),
                  foregroundColor: MaterialStateProperty.all<Color>(kbloodred)),
              hourMinuteTextStyle: GoogleFonts.roboto(
                  fontSize: 30), // Text style for hours and minutes
            ),
            textTheme: TextTheme(
              bodySmall: GoogleFonts.roboto(color: KdarkText),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: kbloodred,
              selectionColor: kbloodred,
              selectionHandleColor: KText,
            ),
          ),
          child: child!,
        );
      },
    );
    formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(time!);
    setState(() {
      startTime = formattedTime!;
    });
    return time;
  }

  //Closetime
  Future<TimeOfDay?> closedTime({
    required BuildContext context,
    String? title,
    String? formattedTime,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Kwhite, // Background color
              hourMinuteTextColor:
                  kbloodred, // Text color for hours and minutes
              dayPeriodTextColor: KdarkText, // Text color for AM/PM
              dayPeriodBorderSide:
                  BorderSide(color: KdarkText), // Border color for AM/PM
              dialHandColor: kbloodred, // Color of the hour hand
              dialTextColor: Kwhite, // Text color on the clock dial
              dialBackgroundColor: kbloodred.withOpacity(0.5),
              //dayPeriodColor: lightBlue,
              //hourMinuteColor: lightBlue,
              entryModeIconColor: kbloodred,
              helpTextStyle: GoogleFonts.roboto(
                color: KText, // Set the text color for "Enter time"
              ),
              cancelButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown.shade300),
                  foregroundColor: MaterialStateProperty.all<Color>(kbloodred)),
              confirmButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.brown.shade300),
                  foregroundColor: MaterialStateProperty.all<Color>(kbloodred)),
              hourMinuteTextStyle: GoogleFonts.roboto(
                  fontSize: 30), // Text style for hours and minutes
            ),
            textTheme: TextTheme(
              bodySmall: GoogleFonts.roboto(color: KdarkText),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: kbloodred,
              selectionColor: kbloodred,
              selectionHandleColor: KText,
            ),
          ),
          child: child!,
        );
      },
    );
    formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(time!);
    setState(() {
      closeTime = formattedTime!;
    });
    return time;
  }

  ///////////////////////////////////////////////////////
  final List<String> Genders = [
    'Male',
    'Female',
    'Others',
  ];
  String? selectedgender;
  //////////////////////////////
  bool showimagenullMessage = false;
  File? selectedImage;
  File? selectedImagetwo;
  String base64Image = "";
  // bool isLoading = false;
  Map typesData = {};
  List<String> options = [];
  int choosenTypeData = 0;
  String choosenOption = "";
  String? selectedValue;
  String description = "";
  int? totalAmount;
  String? str;
  Future<void> chooseImage(type) async {
    var image;
    if (type == "camera") {
      image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 10,
      );
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
    }
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        base64Image = base64Encode(selectedImage!.readAsBytesSync());
        apicontroller.editProfilePicture(selectedImage!); //
        print(selectedImage!.readAsBytesSync().lengthInBytes);
        final kb = selectedImage!.readAsBytesSync().lengthInBytes / 1024;
        print(kb);
        final mb = kb / 1024;
        print(mb);
        print("ram b jk dslnkv flk dlkcdslc k");
        showimagenullMessage = false;
      });
    }
  }

  String? selectedGenderValue;

  @override
  void initState() {
    setState(() {
      apicontroller.editfirstNameController.text =
          apicontroller.profileData["name"] ?? "NA";
    });

    setState(() {});
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
          "Edit Profile",
          style: TextStyle(fontSize: 22.sp, color: kcarden, fontWeight: kFW600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Kwhite,
                    radius: 50.r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.r),
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 100.h,
                              width: 100.w,
                              fit: BoxFit.cover,
                            )
                          : apicontroller.profileData["profilePic"] == null
                              ? Image.asset(
                                  "assets/images/profileImageStatic.png",
                                  height: 100.h,
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                )
                              : CircleAvatar(
                                  backgroundColor: Kwhite,
                                  radius: 50.r,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200.r),
                                    child: CachedNetworkImage(
                                      imageUrl: kBaseImageUrl +
                                          apicontroller
                                              .profileData["profilePic"],
                                      // authentication
                                      //     .profileData["profile"],
                                      placeholder: (context, url) => SizedBox(
                                        height: 100.h,
                                        width: 100.w,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.black12,
                                          highlightColor:
                                              Colors.white.withOpacity(0.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Kwhite.withOpacity(0.5),
                                            ),
                                            height: 100.h,
                                            width: 100.w,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        backgroundColor: Kwhite,
                                        radius: 50.r,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200.r),
                                          child: Image.asset(
                                            "assets/images/profileImageStatic.png",
                                            // height: 150.h,
                                            height: 100.h,
                                            width: 100.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      height: 100.h,
                                      width: 100.w,
                                      //   fit: BoxFit.cover,
                                      fit: BoxFit.cover,
                                    ),
                                    // Image.asset(
                                    //   "assets/images/profileImageStatic.png",
                                    //   // height: 150.h,
                                    //   height: 100.h,
                                    //   width: 100.w,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 4.h,
                    right: 4.w,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            backgroundColor: Kbackground,
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Kbackground,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  height: 100.h,
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          chooseImage("Gallery");
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              color: kbloodred,
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text('Gallery',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12.sp,
                                                    fontWeight: kFW700,
                                                    color: KdarkText)),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          chooseImage("camera");
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              color: kbloodred,
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text('camera',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12.sp,
                                                    fontWeight: kFW700,
                                                    color: KdarkText)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Image.asset(
                        "assets/images/edit.png",
                        color: kbloodred,
                        height: 20.h,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 50.h,
              ),
              CustomFormField(
                enabled: true,
                controller: apicontroller.editfirstNameController,
                obscureText: false,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                fontSize: kFourteenFont,
                fontWeight: FontWeight.w500,
                hintText: "Enter First Name",
                maxLines: 1,
                readOnly: false,
                label: 'First Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
              ),
              Obx(() => apicontroller.ridereditFormLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Kpink,
                      ),
                    )
                  : CustomButton(
                      borderRadius: BorderRadius.circular(10.r),
                      Color: kbloodred,
                      textColor: Kwhite,
                      height: 42.h,
                      width: double.infinity,
                      label: "Update",
                      fontSize: kSixteenFont,
                      fontWeight: kFW500,
                      isLoading: false,
                      onTap: () {
                        var payload = {
                          "Name": apicontroller.editfirstNameController.text,
                          // "lastName": authentication
                          //     .editDonorLastNameController.text,
                          // "email": authentication
                          //     .editBloodBankEmailController.text,
                          // "address": authentication
                          //     .editBloodBanklocationsController.text,
                          // "bloodGroup": authentication
                          //     .donorRegisterBloodGroup.value,
                          // "gender":
                          //     authentication.donorRegisterGender.value,
                          // "dateOfBirth": selectDate.value,
                        };

                        apicontroller.ridereditProfileForm(payload);
                        // var payload = {
                        //   "firstName": authentication
                        //       .editDonorfirstNameController.text,
                        //   "lastName": authentication
                        //       .editDonorLastNameController.text

                        // };
                        // if (_formKey.currentState!.validate()) {
                        //   authentication.donorEditProfile(
                        //       payload, selectedImage!);
                        // }
                      }

                      // Fluttertoast.showToast(
                      //   msg: "Registered Successfully",
                      // );

                      )),

              // Obx(() => authentication.editFormLoading == true
              //     ? Center(
              //         child: CircularProgressIndicator(
              //           color: kbloodred,
              //         ),
              //       )
              //     : authentication.profileData["employeeType"] == "Donor"
              //         ? CustomButton(
              //             borderRadius: BorderRadius.circular(10.r),
              //             Color: kbloodred,
              //             textColor: Kwhite,
              //             height: 42.h,
              //             width: double.infinity,
              //             label: "Update",
              //             fontSize: kSixteenFont,
              //             fontWeight: kFW500,
              //             isLoading: false,
              //             onTap: () {
              //               var payload = {
              //                 "firstName": authentication
              //                     .editDonorfirstNameController.text,
              //                 "lastName": authentication
              //                     .editDonorLastNameController.text,
              //                 "email": authentication
              //                     .editBloodBankEmailController.text,
              //                 "address": authentication
              //                     .editBloodBanklocationsController.text,
              //                 "bloodGroup": authentication
              //                     .donorRegisterBloodGroup.value,
              //                 "gender":
              //                     authentication.donorRegisterGender.value,
              //                 "dateOfBirth": selectDate.value,
              //                 //////////////////////
              //                 // "bloodBankName": authentication
              //                 //     .editBloodBankNameController.text,
              //                 // "email": authentication
              //                 //     .editBloodBankEmailController.text,
              //                 // "address": authentication
              //                 //     .editBloodBanklocationsController.text,
              //                 // "startTime": startTime,
              //                 // "endTime": closeTime,
              //               };

              //               authentication.editProfileForm(payload);
              //               // var payload = {
              //               //   "firstName": authentication
              //               //       .editDonorfirstNameController.text,
              //               //   "lastName": authentication
              //               //       .editDonorLastNameController.text

              //               // };
              //               // if (_formKey.currentState!.validate()) {
              //               //   authentication.donorEditProfile(
              //               //       payload, selectedImage!);
              //               // }
              //             }

              //             // Fluttertoast.showToast(
              //             //   msg: "Registered Successfully",
              //             // );

              //             )
              //         : CustomButton(
              //             borderRadius: BorderRadius.circular(10.r),
              //             Color: kbloodred,
              //             textColor: Kwhite,
              //             height: 42.h,
              //             width: double.infinity,
              //             label: "Update",
              //             fontSize: kSixteenFont,
              //             fontWeight: kFW500,
              //             isLoading: false,
              //             onTap: () {
              //               var payload = {
              //                 "bloodBankName": authentication
              //                     .editBloodBankNameController.text,
              //                 "email": authentication
              //                     .editBloodBankEmailController.text,
              //                 "address": authentication
              //                     .editBloodBanklocationsController.text,
              //                 // Latest Comments
              //                 // "startTime": startTime,
              //                 // "endTime": closeTime,
              //                 // "firstName": authentication
              //                 //     .registerDonorfirstNameController.text,
              //                 //"Ram Nayak",

              //                 //16.5196953
              //               };

              //               authentication.editProfileForm(payload);
              //               // authentication.donorEditProfileBank(
              //               //     payload, selectedImage!);

              //               // "phone": authentication.loginMobileController.text,
              //               //  "8297297247"
              //             }

              //             // Fluttertoast.showToast(
              //             //   msg: "Registered Successfully",
              //             // );

              //             )),

              // CustomButton(
              //   //margin: EdgeInsets.all(10.r),
              //   borderRadius: BorderRadius.circular(10.r),
              //   Color: kbloodred,
              //   textColor: Kwhite,
              //   height: 42.h,
              //   width: double.infinity,
              //   label: "Update Profile",
              //   fontSize: kSixteenFont,
              //   fontWeight: kFW500,
              //   isLoading: false,
              //   onTap: () async {
              //     Fluttertoast.showToast(
              //       msg: "Registered Successfully",
              //     );
              //     Get.back();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
