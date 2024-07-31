import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/Email/otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final _email = TextEditingController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  APIController apiController = APIController();

  bool _submitted = false;

  String? get _errorText {
    final email = _email.value.text.trim();
    if (email.isEmpty) {
      return 'Email wajib diisi';
    } else if (!_isValidEmail(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegExp.hasMatch(email);
  }

  var alertStyle = const AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontSize: 19),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      overlayColor: Color(0x95000000),
      alertElevation: 0,
      alertAlignment: Alignment.center);

  @override
  void initState() {
    super.initState();
    _keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  void clearText() {
    _email.clear();
  }

  @override
  Widget build(BuildContext context) {

    return KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool isKeyboardVisible) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              toolbarHeight: Adaptive.h(8.7),
              title: Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/logo.png',
                          width: Adaptive.w(30),
                        ),
                      ],
                    ),
                  ),
              titleSpacing: 5,
              elevation: 2,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
                size: Adaptive.h(4),
              )),
          body: Center(
              child: SizedBox(
                  height: Adaptive.h(80),
                  width: Adaptive.w(80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text('Masukkan Email',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      const Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                                'Verifikasi email akun Preg-Fit kamu dulu yaaa.',
                                style: TextStyle(
                                    fontFamily: 'DMSans', fontSize: 15.5))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans'),
                              decoration: InputDecoration(
                                hintText: 'Masukkan email anda',
                                errorText: _submitted ? _errorText : null,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: clearText,
                                ),
                              ),
                              controller: _email,
                            )),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Expanded(
                        child: Align(
                          alignment: isKeyboardVisible
                              ? Alignment.topCenter
                              : Alignment.bottomCenter,
                          child: EasyButton(
                            type: EasyButtonType.elevated,
                            onPressed: () async {
                              setState(() => _submitted = true);
                              if (_errorText == null) {
                                var res = await apiController.checkEmail(_email.text);
                                if (res == 409) {
                                  var send;
                                  try {
                                    send = await apiController.sendOTPMail(_email.value.text);
                                  } catch (e) {
                                    send = false;
                                    debugPrint(e.toString());
                                  }
                                  print(send);
                                  if (send == 200 || send == 409) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTPEmail(
                                                  email: _email.text,
                                                )));
                                  }
                                } else {
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    style: alertStyle,
                                    title: 'Warning',
                                    desc:
                                        "Email belum terdaftar di Preg-Fit mom. Silahkan coba lagi.",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () => Navigator.pop(context),
                                        color: Colors.blue,
                                        child: const Text(
                                          "Oke",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ).show();
                                }
                              }
                              return;
                            },
                            loadingStateWidget: const CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            useEqualLoadingStateWidgetDimension: true,
                            useWidthAnimation: true,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.05,
                            borderRadius: 20,
                            buttonColor: Colors.blue,
                            contentGap: 6.0,
                            idleStateWidget: const Text(
                              'LANJUT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'DMSans'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))));
    });
  }
}
