import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Controller/notification_controller.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Screens/Onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPreferredOrientation();

 

  // await Alarm.init();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  NotificationController.startListeningNotificationEvents();

  await GetStorage.init();

  final APIController apiController = APIController();
  
  final bool hasToken = await apiController.checkTokenMain();
   await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(MyApp(hasToken: hasToken,)));

}

void setPreferredOrientation() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  final bool hasToken;
  const MyApp({super.key, required this.hasToken});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(); 

  @override
  Widget build(BuildContext context) {
      return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Preg-Fit',
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: hasToken ? const Menu(index: 0) : const Onboarding(),);
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
