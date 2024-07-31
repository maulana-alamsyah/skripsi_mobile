import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/OTP/otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class NewPhone extends StatefulWidget {
  final String email;
  const NewPhone({super.key, required this.email});

  @override
  State<NewPhone> createState() => _NewPhoneState();
}

class _NewPhoneState extends State<NewPhone> {
  final _phone = TextEditingController();
  final client = HttpClient();
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
                            child: Text('Nomor HP Baru',
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
                                'Masukkan nomor baru untuk akun Preg-Fit kamu.',
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
                                if (_phone.value.text.isNotEmpty) {
                                  var res = await apiController.checkNO(_phone.text);
                                  if (res == 200) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTP(
                                                  phoneNo: _phone.text,
                                                  aksi: 2,
                                                  email: widget.email,
                                                )));
                                  } else if (res == 409) {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      style: alertStyle,
                                      title: 'Warning',
                                      desc:
                                          "Nomor sudah terdaftar mom, silahkan login.",
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
