import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pregfit/Screens/Email/email.dart';
import 'package:pregfit/Screens/OTP/otp.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phone = TextEditingController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  bool _submitted = false;
  APIController apiController = APIController();

  String? get _errorText {
    final phone = _phone.value.text;
    if (phone.isEmpty) {
      return 'Nomor HP wajib diisi';
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
    _phone.clear();
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
                            child: Text('Masukkan nomor HP',
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
                            child: Text('Buat masuk ke akun Preg-Fit kamu.',
                                style: TextStyle(
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
                                    text: 'Nomor HP',
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
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans'),
                              decoration: InputDecoration(
                                hintText: '628xxxx',
                                errorText: _submitted ? _errorText : null,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: clearText,
                                ),
                              ),
                              controller: _phone,
                            )),
                      ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: InkWell(
                              child: const Text(
                                'Ada kendala atau lupa nomor?',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 13,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.left,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Email()));
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
                          child: Row(children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() => _submitted = true);
                                  if (_errorText == null) {
                                    if (_phone.value.text.isNotEmpty) {
                                      var res = await apiController.checkNO(_phone.text);
                                      if (res == 409) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OTP(
                                                    phoneNo: _phone.text,
                                                    aksi: 0,
                                                    email: '',
                                                  )));
                                      } else if (res == 200) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          style: alertStyle,
                                          title: 'Warning',
                                          desc:
                                              "Nomor belum terdaftar mom, silahkan daftar terlebih dahulu.",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
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
                                  }
                                  return;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(
                                      double.infinity,
                                      MediaQuery.of(context).size.height *
                                          0.05),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text(
                                  'LANJUT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'DMSans'),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ))));
    });
  }
}
