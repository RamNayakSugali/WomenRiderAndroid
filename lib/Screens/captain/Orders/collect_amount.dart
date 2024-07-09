import 'package:womentaxi/untils/export_file.dart';

class CollectAmount extends StatefulWidget {
  const CollectAmount({super.key});

  @override
  State<CollectAmount> createState() => _CollectAmountState();
}

class _CollectAmountState extends State<CollectAmount> {
  ApiController apiController = Get.put(ApiController());
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
          "CollectAmount",
          style: TextStyle(
              fontSize: kEighteenFont, fontWeight: kFW500, color: kcarden),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Please Collect Cash 450",
              style: TextStyle(
                  fontSize: kTwentyFont, color: kcarden, fontWeight: kFW600),
            ),
            CustomButton(
                margin: EdgeInsets.only(top: 80.h),
                width: double.infinity,
                height: 42.h,
                fontSize: kFourteenFont,
                fontWeight: kFW700,
                textColor: Kwhite,
                borderRadius: BorderRadius.circular(30.r),
                label: "Collected Cash",
                isLoading: false,
                onTap: () {
                  apiController
                      .completeOrder(apiController.acceptOrderData["_id"]);
                }),
          ],
        ),
      ),
    );
  }
}
