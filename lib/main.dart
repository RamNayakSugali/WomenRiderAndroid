import 'package:flutter/material.dart';
import 'package:mappls_gl/mappls_gl.dart';

import 'package:womentaxi/untils/export_file.dart';
import 'package:rename/rename.dart';
// import 'package:womentaxi/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapplsAccountManager.setMapSDKKey("033f942acd66a3157a6d52a22ee81f18");
  MapplsAccountManager.setRestAPIKey("033f942acd66a3157a6d52a22ee81f18");
  MapplsAccountManager.setAtlasClientId(
      "96dHZVzsAusidhUytn28QkwAnZ6bRAtUugIE6qJQ_3uRKc1qwIl4NIkCiU-a1ttK5UqamKmzCI8DEyXQyTpnow==");
  MapplsAccountManager.setAtlasClientSecret(
      "lrFxI-iSEg9BKENPQ6Yb1lZNFHGWKlr6U-sg5kRdNkAcI6tzAFS9OkmBhZNOQnvFJ9HedN6VELQKTDqsv7wP84qDhhRdyog-");

  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            title: "WOR",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Objectivity',
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent),
            ),
            getPages: Routes.routes,
            initialRoute:
                // KDashboard,
                KSplash,
            //  kAuth_Screen,
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!);
            });
      },
    );
  }
}
