import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:pinput/pinput.dart';
import 'package:pregfit/Screens/Email/new_phone.dart';

class OTPEmail extends StatefulWidget {
  final String email;
  const OTPEmail({super.key, required this.email});

  @override
  State<OTPEmail> createState() => _OTPEmailState();
}

class _OTPEmailState extends State<OTPEmail> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool? isValid;
  late String otp;
  APIController apiController = APIController();
  late bool _submitted = false;
  late bool wrongOTP = false;
  bool hasError = false;

  String? get _errorTextOTP {
    if (wrongOTP) {
      return 'Kode OTP kurang tepat mom.';
    }
    return null;
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
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

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
                            child: Text('Kode verifikasi udah di-Email, ya',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                                'Masukkan kode verifikasi yang kami kirim ke ${widget.email}',
                                style: const TextStyle(
                                    fontFamily: 'DMSans', fontSize: 15.5))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: RichText(
                                text: const TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    text: 'Masukkan Kode Verifikasi',
                                    children: [
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(color: Colors.red))
                                ]))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      Row(children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Pinput(
                              length: 6,
                              controller: pinController,
                              focusNode: focusNode,
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.smsUserConsentApi,
                              listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: defaultPinTheme,
                              separatorBuilder: (index) =>
                                  const SizedBox(width: 8),
                              onClipboardFound: (value) {
                                debugPrint('onClipboardFound: $value');
                                pinController.setText(value);
                              },
                              forceErrorState: hasError,
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              errorText:
                                  _submitted ? _errorTextOTP : null,
                              onCompleted: (pin) async {
                                setState(() => _submitted = true);
                                setState(() {
                                  otp = pin;
                                });
                                var res  = await apiController.verifOTPMail(pin, widget.email);
                                if (res == 200) {
                                  setState(() {
                                    isValid = true;
                                    hasError = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewPhone(email: widget.email)));
                                } else {
                                  wrongOTP = true;
                                  setState(() {
                                    isValid = false;
                                    hasError = true;
                                  });
                                }
                              },
                              onChanged: (value) {
                                if(value.length < 6){
                                  setState(() {
                                    hasError = false;
                                  });
                                }
                                debugPrint('onChanged: $value');
                              },
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 9),
                                    width: 22,
                                    height: 1,
                                    color: focusedBorderColor,
                                  ),
                                ],
                              ),
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  color: fillColor,
                                  borderRadius: BorderRadius.circular(19),
                                  border: Border.all(color: focusedBorderColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: InkWell(
                              child: const Text(
                                'Kirim ulang kode verifikasi?',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 13,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.left,
                              ),
                              onTap: () async {
                                try {
                                  await apiController.sendOTPMail(widget.email);
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    style: alertStyle,
                                    title: 'Success',
                                    desc:
                                        "Kode verifikasi berhasil dikirim, Silahkan cek email Mom",
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
                              },
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
                              var res  = await apiController.verifOTPMail(otp, widget.email);
                              if (res == 200) {
                                setState(() {
                                    isValid = true;
                                    hasError = false;
                                  });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewPhone(email: widget.email)));
                              } else {
                                setState(() {
                                    isValid = false;
                                    hasError = true;
                                  });
                              }
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
                              'VERIFIKASI',
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
