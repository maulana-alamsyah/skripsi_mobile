import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pregfit/Controller/notification_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Screens/Onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPreferredOrientation();

  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));

  // await Alarm.init();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  NotificationController.startListeningNotificationEvents();
}

void setPreferredOrientation() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Preg-Fit',
        debugShowCheckedModeBanner: false,
        home: const Onboarding(),
      );
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
