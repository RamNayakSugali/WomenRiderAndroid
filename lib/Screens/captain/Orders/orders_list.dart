import 'package:womentaxi/untils/export_file.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  ApiController apiController = Get.put(ApiController());
  @override
  void initState() {
    apiController.getCurrentLocation();
    // TODO: implement initState
    super.initState();
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
          "Orders List",
          style: TextStyle(
              fontSize: kEighteenFont, fontWeight: kFW500, color: kcarden),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(15.w),
            child: Obx(
              () => apiController.ordersLoadings == true
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.h),
                      child: CircularProgressIndicator(
                        color: Kpink,
                      ),
                    )
                  : apiController.orders.isEmpty || apiController.orders == null
                      ? Text(
                          "No Orders",
                          style: GoogleFonts.roboto(
                              fontSize: kSixteenFont,
                              color: KdarkText,
                              fontWeight: kFW500),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: apiController.orders.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 18.r,
                                          backgroundColor:
                                              Ktextcolor.withOpacity(0.5),
                                          child:
                                              Icon(Icons.pedal_bike_outlined)),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Bike",
                                        style: TextStyle(
                                            fontSize: kFourteenFont,
                                            color: kcarden,
                                            fontWeight: kFW500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: greenColor,
                                        radius: 5.r,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pick",
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
                                              apiController.orders[index]
                                                      ["pickupAddress"] ??
                                                  "NA",

                                              //   "325, High Tension Line Rd, Srinivas Colony, Aditya Nagar, Kukatpally, Hyderabad, Telangana 500072",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  color: Ktextcolor,
                                                  fontWeight: kFW500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: kbloodred,
                                        radius: 5.r,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Drop Point",
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
                                              apiController.orders[index]
                                                      ["dropAddress"] ??
                                                  "NA",

                                              //  "Suryey no 305 Opp Tulsi vanam Ladies Hostel Paradise Lane, South india Shopping mall, beside Lane, Kukatpally Housing Board Colony, Kukatpally, Hyderabad, Telangana 500072",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  color: Ktextcolor,
                                                  fontWeight: kFW500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pick Up",
                                            style: TextStyle(
                                                fontSize: kFourteenFont,
                                                color: Ktextcolor,
                                                fontWeight: kFW500),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            "${apiController.orders[index]["pickUpdistance"]}" ??
                                                "0",
                                            //    "0.4 km",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                color: kcarden,
                                                fontWeight: kFW500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 25.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Drop",
                                            style: TextStyle(
                                                fontSize: kFourteenFont,
                                                color: Ktextcolor,
                                                fontWeight: kFW500),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              "${apiController.orders[index]["dropdistance"]}" ??
                                                  "0",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: kcarden,
                                                  fontWeight: kFW500),
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
                                    children: [
                                      SizedBox(
                                        width: 50.w,
                                      ),
                                      CustomButton(
                                          width: 100.w,
                                          height: 42.h,
                                          fontSize: kFourteenFont,
                                          fontWeight: kFW700,
                                          textColor: Kwhite,
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          label: "Accept",
                                          isLoading: false,
                                          onTap: () async {
                                            apiController.acceptOrder(
                                                apiController.orders[index]
                                                    ["_id"]);

                                            // Get.toNamed(kArrivedScreen);
                                            //  KOtpVerification
                                            //  await Get.toNamed(kOtpVerify);
                                          }),
                                      SizedBox(
                                        width: 50.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          apiController.declineOrder(
                                              apiController.orders[index]
                                                  ["_id"]);
                                        },
                                        child: Container(
                                          //padding: Padding,
                                          height: 42.h,
                                          width: 100.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                              border: Border.all(
                                                  color: kbloodred, width: 1)),
                                          child: Text(
                                            "Decline",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: kFourteenFont,
                                                color: kbloodred,
                                                fontWeight: kFW700),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
            )),
      ),
    );
  }
}
