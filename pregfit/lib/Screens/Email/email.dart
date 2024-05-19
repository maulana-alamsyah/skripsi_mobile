import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/Email/otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:email_otp/email_otp.dart';
import 'package:email_auth/email_auth.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final _email = TextEditingController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  final client = HttpClient();
  EmailOTP myauth = EmailOTP();

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

  var emailAuth = EmailAuth(
    sessionName: "Sample session",
  );

  void sendOtp() async {
    bool result =
        await emailAuth.sendOtp(recipientMail: _email.value.text, otpLength: 5);
    if (result) {
      print('berhasil send otp');
    }
  }

  Future<dynamic> checkEmail(String email) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'email': email}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/check_email"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'email': email}));

      final response = await request.close();

      return response.statusCode;
    } catch (e) {
      if (e is SocketException) {
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
  }

  @override
  Widget build(BuildContext context) {
    myauth.setSMTP(
        host: "smtp.mailersend.net",
        auth: true,
        username: "MS_cWDmcM@trial-0r83ql3j0vpgzw1j.mlsender.net",
        password: "Uv3CwFpZRt2aQ51S",
        secure: "TLS",
        port: 587);

    myauth.setTheme(theme: "v1");

    var template = '''<html>
    <body>
<div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden;">
        <div style="background-color: #fff;; padding: 0 20px; text-align: center; color: #7F91AA;">
            <img style="display: block; margin: 0 auto; width: 80px;" src="https://i.ibb.co/vqMCTdS/Untitled-design-4.png" title="logo" alt="logo" data-bit="iit">
            <h1 style="margin-top: 0;">Preg-Fit</h1>
        </div>
        <div style="height: 1px; background-color: #ecf0f1; margin: 20px 0;"></div>
        <p>Hi Mom!<br/><br/>Ini dia kode rahasia kita. Jangan berikan kode ini ke siapa pun untuk alasan keamanan ya! <br/>Gunakan kode ini hanya untuk verifikasi akun <strong>{{app_name}}</strong> mom.<br/> Semoga hari mom menyenangkan yaa &#129392; &#129392;.</p><br> 
      <center><span style="background: red; padding: 5px 15px 5px 15px; font-size: 20px; font-weight: bold; border-radius: 20px; color: white; background-color: #2c3e50;">{{otp}}</span></center>
            <div style="height: 1px; background-color: #ecf0f1; margin: 20px 0;"></div>
        <div style="text-align: center; padding: 20px; background-color: #ecf0f1;">
            <p style="font-size: 14px; color: #03265B; margin: 0;">&copy; <strong>Preg-Fit</strong></p><div class="yj6qo"></div><div class="adL">
        </div></div><div class="adL">
    </div></div>
<!--''';
    myauth.setTemplate(render: template);

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
                                var res = await checkEmail(_email.text);
                                if (res == 409) {
                                  sendOtp();
                                  myauth.setConfig(
                                      appEmail:
                                          "MS_cWDmcM@trial-0r83ql3j0vpgzw1j.mlsender.net",
                                      appName: "Preg-Fit",
                                      userEmail: _email.text,
                                      otpLength: 6,
                                      otpType: OTPType.digitsOnly);
                                  var send;
                                  try {
                                    send = await myauth.sendOTP();
                                  } catch (e) {
                                    send = false;
                                    print(e);
                                  }
                                  if (send == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTPEmail(
                                                  email: _email.text,
                                                  myauth: myauth,
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
