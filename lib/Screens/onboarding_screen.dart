import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:womentaxi/untils/export_file.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _pageController = PageController();
  int pageIndex = 0;
  List<Map> splashPages = [
    {
      'title': 'Welcome to the  Women Raider ',
      'maintitle': "We are happy",
      'maintitle1': 'to have you',
      'maintitle2': '',
      'maintitle3': 'onboard',
      'image': "assets/images/ladyrider.png",
      // "subimage": 'assets/images/onboarding/board_one_approval_image.png'
      // "subimage": 'assets/images/onboarding/frame4.png'
    },
    // {
    //   'title': 'More than a HRMS tool ',
    //   'maintitle': 'Make Employees ',
    //   'maintitle1': 'work easier with',
    //   'maintitle2': 'VIBHO',
    //   'maintitle3': 'HCM',
    //   'image': 'assets/images/onboarding/frame1.png',
    //   "subimage": 'assets/images/onboarding/frame4.png'
    // },
    // Enjoy every moment of your journey
    {
      'title': 'Explore your latest App ',
      'maintitle': 'Enjoy every',
      'maintitle1': 'moment of',
      'maintitle2': "your ",
      'maintitle3': 'journey',
      'image': "assets/images/taxi_board_two.jpg",
      // 'subimage': 'assets/images/onboarding/board_two_profile_image.png'
      // 'subimage': 'assets/images/onboarding/frame3.png'
    },
    // {
    //   'title': 'More than a HRMS tool ',
    //   'maintitle': 'Make Employees ',
    //   'maintitle1': 'work easier with',
    //   'maintitle2': 'VIBHO',
    //   'maintitle3': 'HCM',
    //   'image': 'assets/images/onboarding/frame4.png',
    //   'subimage': 'assets/images/onboarding/frame3.png'
    // },
    // Experience features that await you
    {
      'title': 'Get Started! ',
      'maintitle': 'Experience',
      'maintitle1': 'features',
      'maintitle2': 'that ',
      'maintitle3': 'await you',
      'image': "assets/images/woman_parcel.jpg",
      //   "subimage": 'assets/images/onboarding/board_three_earnings_image.png'
      // "subimage": 'assets/images/onboarding/frame6.png'
    },
    // {
    //   'title': 'More than a HRMS tool',
    //   'maintitle': 'Make Employees',
    //   'maintitle1': 'work easier with',
    //   'maintitle2': 'VIBHO',
    //   'maintitle3': 'HCM',
    //   'image': 'assets/images/onboarding/frame5.png',
    //   "subimage": 'assets/images/onboarding/frame6.png'
    // },
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (currentPage == 0) {
            SystemNavigator.pop();
          } else {
            _pageController.animateToPage(_pageController.page!.toInt() - 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn);
          }
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Kwhite,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // IconButton(
                            //     onPressed: () {
                            //       _pageController.previousPage(
                            //           duration: const Duration(milliseconds: 200),
                            //           curve: Curves.linear);
                            //     },
                            //     icon: const Icon(
                            //       Icons.arrow_back,
                            //       color: KdarkText,
                            //       size: 25,
                            //     )),
                            InkWell(
                              onTap: () {
                                Get.toNamed(kSelectType);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Skip",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: KlightText),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: KlightText,
                                    size: 25,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 500.h,
                              //color: KlightBlue,
                              child: PageView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPage = value;
                                  });
                                },
                                itemCount: splashPages.length,
                                itemBuilder: (context, index) {
                                  return SplashPageContent(
                                    title: splashPages[index]['title'],
                                    maintitle: splashPages[index]['maintitle'],
                                    maintitle1: splashPages[index]
                                        ['maintitle1'],
                                    maintitle2: splashPages[index]
                                        ['maintitle2'],
                                    maintitle3: splashPages[index]
                                        ['maintitle3'],
                                    image: splashPages[index]['image'],
                                    //subimage: splashPages[index]['subimage'],
                                  );
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 10.w,
                              ),
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: splashPages.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 6,
                                  dotWidth: 10,
                                  dotColor: Kpink.withOpacity(0.1),
                                  activeDotColor: Kpink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: InkWell(
                          onTap: () {
                            if (currentPage == splashPages.length - 1) {
                            } else {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linear);
                            }
                          },
                          child: currentPage == splashPages.length - 1
                              ? GestureDetector(
                                  onTap: () {
                                    Get.toNamed(kSelectType);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: Kpink
                                        //gradient: ButtonBlueGradient,
                                        ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Get Started",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: kFW600,
                                              color: Kwhite),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Kwhite,
                                              size: 16,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: Kpink
                                      // gradient: ButtonBlueGradient,
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: kFW600,
                                            color: Kwhite),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Icon(
                                          //   Icons.arrow_forward_ios,
                                          //   color: Kwhite.withOpacity(0.4),
                                          //   size: 12,
                                          // ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Kwhite,
                                            size: 16,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class SplashPageContent extends StatelessWidget {
  const SplashPageContent({
    Key? key,
    required this.title,
    required this.maintitle,
    required this.maintitle1,
    required this.maintitle3,
    required this.maintitle2,
    required this.image,
    //  required this.subimage
  }) : super(key: key);

  final String title;

  final String maintitle;
  final String maintitle1;
  final String maintitle2;
  final String maintitle3;
  final String image;
  // final String subimage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          //color: KOrange,
          child: FadeInImage(
            placeholder: AssetImage(
              "assets/images/white_image.png",
            ),
            fit: BoxFit.cover,
            image: AssetImage(image),
            fadeInDuration: Duration(
                milliseconds: 200), // Adjust the duration of the fade-in effect
            width: 200.w, // Choose the BoxFit that suits your layout
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          //  height: 80.h,
          width: 300.w,
          child: Row(
            children: [
              Text(title,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: kFW500,
                  )),
              // Image.asset("assets/images/onboarding/hr.png")
            ],
          ),
        ),
        SizedBox(
          // height: 80.h,
          width: 300.w,
          child: Text(maintitle,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 26.sp, fontWeight: kFW700, color: KdarkText)),
        ),
        SizedBox(
          // height: 80.h,
          width: 300.w,
          child: Text(maintitle1,
              maxLines: 1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 26.sp, fontWeight: kFW700, color: KdarkText)),
        ),
        Row(
          children: [
            Text(maintitle2,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 26.sp, fontWeight: kFW700, color: KdarkText)),
            Text(maintitle3,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 26.sp, fontWeight: kFW700, color: Kpink)),
          ],
        ),
      ],
    );
  }
}
