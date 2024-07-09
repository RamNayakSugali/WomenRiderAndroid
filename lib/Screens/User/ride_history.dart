import 'package:womentaxi/untils/export_file.dart';

class RideHistory extends StatefulWidget {
  const RideHistory({super.key});

  @override
  State<RideHistory> createState() => _RideHistoryState();
}

UserApiController userapiController = Get.put(UserApiController());

class _RideHistoryState extends State<RideHistory> {
  @override
  void initState() {
    userapiController.getUserOrders();
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
          "Rides History",
          style: TextStyle(
              fontSize: kEighteenFont, fontWeight: kFW500, color: kcarden),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(15.w),
            child: Obx(
              () => userapiController.userOrdersDataLoading == true
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.h),
                      child: CircularProgressIndicator(
                        color: Kpink,
                      ),
                    )
                  : userapiController.userOrders.isEmpty ||
                          userapiController.userOrders == null
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
                          itemCount: userapiController.userOrders.length,
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.motorcycle,
                                        color: Kpink.withOpacity(
                                          0.5,
                                        ),
                                        size: 24.sp,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 200.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "325,HMT HILLS,Kukatpally",
                                              style: TextStyle(
                                                  fontSize: kSixteenFont,
                                                  color: kcarden,
                                                  fontWeight: kFW500),
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            SizedBox(
                                              width: 270.w,
                                              child: Text(
                                                userapiController
                                                            .userOrders[index]
                                                        ["orderPlaceDate"] ??
                                                    "" +
                                                        " -   " +
                                                        userapiController
                                                                    .userOrders[
                                                                index][
                                                            "orderPlaceTime"] ??
                                                    "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: kTwelveFont,
                                                    color: Ktextcolor,
                                                    fontWeight: kFW500),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              userapiController
                                                          .userOrders[index]
                                                      ["status"] ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  color: KlightText,
                                                  fontWeight:
                                                      kFW500), // KlightText
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Kpink.withOpacity(
                                      0.5,
                                    ),
                                    size: 24.sp,
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
