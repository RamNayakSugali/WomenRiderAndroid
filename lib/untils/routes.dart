// import 'package:nuhvinbloodbank/untils/export_file.dart';
import 'package:womentaxi/untils/export_file.dart';

class Routes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
        name: KSplash,
        transition: Transition.rightToLeft,
        page: () => SplashScreen()),
    GetPage(
        name: KOnboarding,
        transition: Transition.rightToLeft,
        page: () => OnBoarding()),
    GetPage(
        name: KMobileRegistration,
        transition: Transition.rightToLeft,
        page: () => PhoneRegistration()),
    GetPage(
        name: KOtpVerification,
        transition: Transition.rightToLeft,
        page: () => OtpVerify()),
    GetPage(
        name: KDashboard,
        transition: Transition.rightToLeft,
        page: () => Dashboard()),
    GetPage(
        name: KNotifications,
        transition: Transition.rightToLeft,
        page: () => Notifications()),
    GetPage(
        name: KProfile,
        transition: Transition.rightToLeft,
        page: () => Profile()),
    GetPage(
        name: KEarningsScreen,
        transition: Transition.rightToLeft,
        page: () => EarningsScreen()),
    GetPage(
        name: kAcceptOrders,
        transition: Transition.rightToLeft,
        page: () => OrdersList()),
    GetPage(
        name: kArrivedScreen,
        transition: Transition.rightToLeft,
        page: () => ArrivedScreen()),
    GetPage(
        name: kDropScreen,
        transition: Transition.rightToLeft,
        page: () => DropScreen()),
    GetPage(
        name: kSelectType,
        transition: Transition.rightToLeft,
        page: () => SelectFlow()),
    GetPage(
        name: kUserDashboard,
        transition: Transition.rightToLeft,
        page: () => UserDashboard()),
    GetPage(
        name: kUserSelectDrop,
        transition: Transition.rightToLeft,
        page: () => UserSelectDrop()),
    GetPage(
        name: kUserBookRide,
        transition: Transition.rightToLeft,
        page: () => UserBookRide()),
    GetPage(
        name: kUserProfile,
        transition: Transition.rightToLeft,
        page: () => UserProfile()),
    GetPage(
        name: kUserNotifications,
        transition: Transition.rightToLeft,
        page: () => UserNotifications()),
    GetPage(
        name: kUserRideHistory,
        transition: Transition.rightToLeft,
        page: () => RideHistory()),
    GetPage(
        name: kUserPayments,
        transition: Transition.rightToLeft,
        page: () => UserPayments()),
    GetPage(
        name: kUserRaidOtp,
        transition: Transition.rightToLeft,
        page: () => RaidOtp()),
    GetPage(
        name: kUserParcel,
        transition: Transition.rightToLeft,
        page: () => ParcelScreen()),
    GetPage(
        name: kUserParcelAddress,
        transition: Transition.rightToLeft,
        page: () => ParcelAddressScreen()),
    GetPage(
        name: kUserParcelDetails,
        transition: Transition.rightToLeft,
        page: () => ParcelContactDetails()),
    GetPage(
        name: kUserRestaurantList,
        transition: Transition.rightToLeft,
        page: () => UserRestaurantList()),
    GetPage(
        name: kUserRestaurantDetail,
        transition: Transition.rightToLeft,
        page: () => restaurant_detail()),
    GetPage(
        name: kUserCart,
        transition: Transition.rightToLeft,
        page: () => Cart_screen()),
    GetPage(
        name: kUserConfirmOrder,
        transition: Transition.rightToLeft,
        page: () => Confirm_order()),
    GetPage(
        name: kUserOrdersHistory,
        transition: Transition.rightToLeft,
        page: () => My_orders()),
    GetPage(
        name: kUserPhoneRegister,
        transition: Transition.rightToLeft,
        page: () => UserPhoneRegistration()),
    GetPage(
        name: kUserOtpVerify,
        transition: Transition.rightToLeft,
        page: () => UserOtpVerify()),
    GetPage(
        name: kCollectAmount,
        transition: Transition.rightToLeft,
        page: () => CollectAmount()),
    GetPage(
        name: kFacialBiometric,
        transition: Transition.rightToLeft,
        page: () => AppBiometric()),
    GetPage(
        name: kFingerPrints,
        transition: Transition.rightToLeft,
        page: () => FingerprintScreen()),
    GetPage(
        name: kTrackingScreen,
        transition: Transition.rightToLeft,
        page: () => DeliveryScreen()),
    GetPage(
        name: kMappleLocationScreen,
        transition: Transition.rightToLeft,
        page: () => MapplScreen()),
    GetPage(
        name: KSignUp,
        transition: Transition.rightToLeft,
        page: () => SignUp()),
    GetPage(
        name: kCompletedOrdersScreen,
        transition: Transition.rightToLeft,
        page: () => CompletedOrdersList()),
    GetPage(
        name: kMergeMapplsScreen,
        transition: Transition.rightToLeft,
        page: () => MapScreen()),
    GetPage(
        name: kAuth_Screen,
        transition: Transition.rightToLeft,
        page: () => AuthScreen()),
    GetPage(
        name: kEditProfileScreen,
        transition: Transition.rightToLeft,
        page: () => EditProfile()),

    // kMappleLocationScreen

//
// kCollectAmount
// kUserOtpVerify
// kUserPhoneRegister

    // kUserOrdersHistory

    // kUserConfirmOrder

// kUserCart
    //  kUserRestaurantDetail
    // kUserRestaurantList

// kUserParcelDetails
    //  kUserParcelAddress

//   kUserParcel
    // kUserRaidOtp

// kUserPayments
//   kUserRideHistory
// kUserNotifications
    // kUserProfile

// kUserBookRide
    // kUserSelectDrop
// kUserDashboard
    // kSelectType

    // kArrivedScreen
// kAcceptOrders
    // KEarningsScreen
    // KProfile
// KNotifications
    // KDashboard
    // KOtpVerification
    // KMobileRegistration
    // KOnboarding
  ];
}
