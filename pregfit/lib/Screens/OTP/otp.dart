import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:pinput/pinput.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OTP extends StatefulWidget {
  final String phoneNo;
  final int aksi;
  final String email;
  const OTP(
      {super.key,
      required this.phoneNo,
      required this.aksi,
      required this.email});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  APIController apiController = APIController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool? isValid;
  late String otp;
  late bool wrongOTP = false;
  String errorMessage = '';
  bool hasError = false;
  late bool _submitted = false;
  final box = GetStorage();

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
  void initState() {
    super.initState();
    generateOtp(modifyNumber(widget.phoneNo), false);
    _keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  String modifyNumber(String inputNumber) {
    if (inputNumber.startsWith('0')) {
      return '+62${inputNumber.substring(1)}';
    }
    return inputNumber;
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  Future<void> generateOtp(String contact, bool status) async {
    try {
      var res = await apiController.sendOTP(contact);
      if (res == 200 && status) {
        Alert(
          context: context,
          type: AlertType.success,
          style: alertStyle,
          title: 'Success',
          desc: "OTP berhasil dikirim.",
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
              child: const Text(
                "Oke",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      } else if(res != 200 && status) {
        Alert(
              context: context,
              type: AlertType.error,
              style: alertStyle,
              title: 'Error',
              desc: "Gagal kirim OTP",
              buttons: [
                DialogButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.blue,
                  child: const Text(
                    "Oke",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ).show();
      }
    } catch (e) {
      Alert(
              context: context,
              type: AlertType.error,
              style: alertStyle,
              title: 'Error',
              desc: "Gagal kirim OTP",
              buttons: [
                DialogButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.blue,
                  child: const Text(
                    "Oke",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ).show();
    }
  }

  Future<bool> verifyOtp(String contact, int action, String otp, String email) async {
  try {
    Map<String, dynamic> res = await apiController.verifOTP(contact, action, otp, email: email);
    debugPrint(res.toString());

    if (res.containsKey('token') && res['token'] != null) {
      box.write('token', res['token']);
      return true;
    } else {
      // showAlert(context, 'Error', 'OTP tidak valid');
      return false;
    }
  } catch (e) {
    // showAlert(context, 'Error', 'Gagal verifikasi');
    return false;
  }
}

  void showAlert(BuildContext context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.error,
      style: alertStyle,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
          child: const Text(
            "Oke",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
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
                            child: Text('OTP udah di-SMS, ya',
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
                                'Masukkan OTP yang kami kirim ke ${widget.phoneNo}',
                                style: const TextStyle(
                                    fontFamily: 'DMSans', fontSize: 15.5))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                    text: 'Masukkan OTP',
                                    children: const [
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(color: Colors.red))
                                ]))),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Container(
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
                                errorText:
                                  _submitted ? _errorTextOTP : null,
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                onCompleted: (pin) async {
                                  setState(() => _submitted = true);
                                  setState(() => otp = pin);
                                  try {
                                    bool res = await verifyOtp(widget.phoneNo, widget.aksi, pin, widget.email);
                                    debugPrint(res.toString());
                                    if(res){
                                    setState(() {
                                        isValid = true;
                                        hasError = false;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Menu(
                                                  index: 0,
                                                )));
                                    }else{
                                      wrongOTP = true;
                                      setState(() {
                                        isValid = false;
                                        hasError = true;
                                      });
                                    }
                                  } catch (e) {
                                    wrongOTP = true;
                                      setState(() {
                                        isValid = false;
                                        hasError = true;
                                      });
                                    debugPrint(e.toString());
                                  }
                                },
                                onChanged: (value) {
                                  if(value.length < 6){
                                    setState(() {
                                      hasError = false;
                                    });
                                  }
                                  debugPrint('onChanged: $value');
                                  setState(() => otp = value);
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
                                    border:
                                        Border.all(color: focusedBorderColor),
                                  ),
                                ),
                                submittedPinTheme: defaultPinTheme.copyWith(
                                  decoration:
                                      defaultPinTheme.decoration!.copyWith(
                                    color: fillColor,
                                    borderRadius: BorderRadius.circular(19),
                                    border:
                                        Border.all(color: focusedBorderColor),
                                  ),
                                ),
                                errorPinTheme: defaultPinTheme.copyBorderWith(
                                  border: Border.all(color: Colors.redAccent),
                                ),
                              ),
                            )),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: InkWell(
                              child: const Text(
                                'Kirim ulang OTP?',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 13,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.left,
                              ),
                              onTap: () {
                                generateOtp(
                                    modifyNumber(widget.phoneNo), true);
                              },
                            )),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Expanded(
                        child: Align(
                          alignment: isKeyboardVisible
                              ? Alignment.topCenter
                              : Alignment.bottomCenter,
                          child: EasyButton(
                            type: EasyButtonType.elevated,
                            onPressed: () async {
                              try {
                                bool res = await verifyOtp(widget.phoneNo, widget.aksi, otp, widget.email);
                                if(res){
                                  setState(() {
                                    isValid = true;
                                    hasError = false;
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Menu(
                                              index: 0,
                                            )));
                                }else{
                                  setState(() {
                                    isValid = false;
                                    hasError = true;
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                    isValid = false;
                                    hasError = true;
                                  });
                                debugPrint(e.toString());
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
