import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pregfit/Config/config.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:pinput/pinput.dart';
import 'package:pregfit/Screens/Home/home.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OTP extends StatefulWidget {
  final String phoneNo;
  final String aksi;
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
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool? isValid;
  late String otp;
  final client = HttpClient();
  String errorMessage = '';

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
    // generateOtp('+${modifyNumber(widget.phoneNo)}', false);
    _keyboardVisibilitySubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  String modifyNumber(String inputNumber) {
    if (inputNumber.startsWith('0')) {
      return '62${inputNumber.substring(1)}';
    }
    return inputNumber;
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        print('invalid code');
        break;
      default:
        String? err = error.message;
        Alert(
          context: context,
          type: AlertType.error,
          style: alertStyle,
          title: 'Error',
          desc: err!,
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
        break;
    }
  }

  Future<dynamic> attemptLogIn(String noHp) async {
    final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHp}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/signin"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHp}));

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else {
        return jsonDecode(await response.transform(utf8.decoder).join());
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
      } else {
        // Handle other exceptions
        print('Error: $e');
      }
    }
  }

  Future<dynamic> attemptLogInhtp(String noHp) async {
    try {
      final url = Uri.parse('${Config.baseURL}/api/signin');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode(noHp))}'
      };
      final response = await http.post(url, headers: headers);

      return jsonDecode(response.body);
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
      } else {}
    }
  }

  Future<dynamic> attemptRegister(String noHp) async {
    final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHp}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHp}));

      final response = await request.close();

      if (response.statusCode == 201) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 409) {
        return 'nomor sudah terdaftar';
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
      } else {
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
    }
  }

  Future<dynamic> updateNoHP(String noHp, String email) async {
    final requestBodyBytes =
        utf8.encode(json.encode({'no_hp_baru': noHp, 'email': email}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/update_nohp"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp_baru': noHp, 'email': email}));

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 500) {
        return 'No HP tidak dapat digunakan, atau sudah digunakan pengguna lain';
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
      } else {
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
    }
  }

  Future<dynamic> checkNO(String noHp) async {
    final requestBodyBytes = utf8.encode(json.encode({'no_hp': noHp}));
    try {
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/check_no"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'no_hp': noHp}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
      } else {
        if (mounted) {
          Alert(
            context: context,
            type: AlertType.error,
            style: alertStyle,
            title: 'Error',
            desc: "Tidak dapat terhubung dengan server",
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
    }
  }

  // Future<void> generateOtp(String contact, bool status) async {
  //   print('status $status');
  //   final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
  //     verificationId = verId;
  //   };
  //   try {
  //     await _auth.verifyPhoneNumber(
  //         phoneNumber: contact,
  //         codeAutoRetrievalTimeout: (String verId) {
  //           verificationId = verId;
  //         },
  //         codeSent: smsOTPSent,
  //         timeout: const Duration(seconds: 60),
  //         verificationCompleted: (AuthCredential phoneAuthCredential) {
  //           print('tes');
  //           if (status) {
  //             Alert(
  //               context: context,
  //               type: AlertType.success,
  //               style: alertStyle,
  //               title: 'Success',
  //               desc: "OTP berhasil dikirim.",
  //               buttons: [
  //                 DialogButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   color: Colors.blue,
  //                   child: const Text(
  //                     "Oke",
  //                     style: TextStyle(color: Colors.white, fontSize: 20),
  //                   ),
  //                 )
  //               ],
  //             ).show();
  //           }
  //         },
  //         verificationFailed: (FirebaseAuthException exception) {
  //           Alert(
  //             context: context,
  //             type: AlertType.error,
  //             style: alertStyle,
  //             title: 'Error',
  //             desc: "Gagal verifikasi",
  //             buttons: [
  //               DialogButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 color: Colors.blue,
  //                 child: const Text(
  //                   "Oke",
  //                   style: TextStyle(color: Colors.white, fontSize: 20),
  //                 ),
  //               )
  //             ],
  //           ).show();
  //         });
  //     print('ok');
  //   } catch (e) {
  //     handleError(e as PlatformException);
  //   }
  // }

  // Future<void> verifyOtp(String smsOTP) async {
  //   if (smsOTP == '') {
  //     print('please enter 6 digit otp');
  //     return;
  //   }
  //   try {
  //     final AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: smsOTP,
  //     );
  //     await _auth.signInWithCredential(credential);

  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => const Menu(
  //                   index: 0,
  //                 )));
  //   } catch (e) {
  //     print(e);
  //     Alert(
  //       context: context,
  //       type: AlertType.error,
  //       style: alertStyle,
  //       title: 'Error',
  //       desc: "OTP tidak valid.",
  //       buttons: [
  //         DialogButton(
  //           onPressed: () => Navigator.pop(context),
  //           color: Colors.blue,
  //           child: const Text(
  //             "Oke",
  //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //         )
  //       ],
  //     ).show();
  //   }
  // }

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
                  child: Image.asset('assets/icons/logo.png',
                      width: Adaptive.w(30))),
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
                                validator: (value) {
                                  if (isValid != null && isValid == true) {
                                    return null;
                                  }
                                  return 'OTP kurang tepat mom';
                                },
                                // onClipboardFound: (value) {
                                //   debugPrint('onClipboardFound: $value');
                                //   pinController.setText(value);
                                // },
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                onCompleted: (pin) async {
                                  debugPrint('onCompleted: $pin');
                                },
                                onChanged: (value) {
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
                                // generateOtp(
                                //     '+${modifyNumber(widget.phoneNo)}', true);
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Menu(
                                            index: 0,
                                          )));
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
