import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pregfit/Screens/Login/login.dart';
import 'package:pregfit/Screens/Register/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
    );
    DateTime? currentPress;
    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 24, fontFamily: 'DMSans', fontWeight: FontWeight.bold),
        titlePadding: EdgeInsets.only(bottom: 3, left: 3, right: 3),
        fullScreen: true,
        imageFlex: 1,
        bodyFlex: 1,
        imagePadding: EdgeInsets.all(0),
        bodyPadding: EdgeInsets.all(10));

    const pageDecoration1 = PageDecoration(
      bodyPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.only(bottom: 3, left: 3, right: 3),
      fullScreen: true,
      imageFlex: 1,
      bodyFlex: 1,
      titleTextStyle: TextStyle(
          fontSize: 24, fontFamily: 'DMSans', fontWeight: FontWeight.bold),
    );

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          final now = DateTime.now();
          if (currentPress == null ||
              now.difference(currentPress!) > const Duration(seconds: 2)) {
            currentPress = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tekan kembali sekali lagi untuk keluar.'),
                duration: Duration(seconds: 1),
              ),
            );
            return;
          } else {
            SystemNavigator.pop();
          }
        },
        child: IntroductionScreen(
            resizeToAvoidBottomInset: false,
            globalBackgroundColor: Colors.white,
            pages: [
              PageViewModel(
                  titleWidget: Text(
                    'Selamat datang, Mom’s!',
                    style: TextStyle(
                        fontSize: 21.sp,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  bodyWidget: Center(
                      child: Column(
                    children: [
                      Text(
                        'Aplikasi Preg-Fit siap mendampingi',
                        style: TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                      ),
                      Text(
                        'mom’s senam ibu hamil mandiri',
                        style: TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                      ),
                      Text(
                        'dimana pun, dan kapan pun.',
                        style: TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                      ),
                    ],
                  )),
                  image: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                  height: Adaptive.h(40),
                                  child: Image.asset(
                                      'assets/images/onboarding-1.png',
                                      width: Adaptive.w(50),
                                      height: Adaptive.h(50)))))),
                  decoration: pageDecoration),
              PageViewModel(
                  useScrollView: false,
                  titleWidget: Text(
                    'Trimester',
                    style: TextStyle(
                        fontSize: 21.sp,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  image: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                  height: Adaptive.h(40),
                                  child: Image.asset(
                                      'assets/images/onboarding-2.png',
                                      width: Adaptive.w(70),
                                      height: Adaptive.h(70)))))),
                  decoration: pageDecoration1,
                  bodyWidget: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Gerakan Senam di Aplikasi Preg-Fit',
                          style:
                              TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                        ),
                        Text(
                          'menyesuaikan usia kandungan',
                          style:
                              TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                        ),
                        Text(
                          'Mom’s',
                          style:
                              TextStyle(fontSize: 17.sp, fontFamily: 'DMSans'),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * 0.43,
                                MediaQuery.of(context).size.height * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding:
                                EdgeInsets.symmetric(vertical: Adaptive.h(0.5)),
                          ),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'DMSans'),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * 0.43,
                                MediaQuery.of(context).size.height * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.blue)),
                            backgroundColor: Colors.white,
                            padding:
                                EdgeInsets.symmetric(vertical: Adaptive.h(0.5)),
                          ),
                          child: Text(
                            'Daftar yuk!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.sp,
                                fontFamily: 'DMSans'),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
            onDone: () {},
            showBackButton: false,
            showSkipButton: true,
            showDoneButton: false,
            showNextButton: true,
            back: const Icon(Icons.arrow_back),
            skip: const Text('Skip',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            next: const Icon(
              Icons.arrow_forward,
              color: Colors.blue,
            ),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: Colors.blue,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)))));
  }
}
