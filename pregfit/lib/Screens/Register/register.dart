import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/ChatBot/chatbot.dart';
import 'package:pregfit/Screens/OTP/otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  APIController apiController = APIController();
  final _phone = TextEditingController();
  final client = HttpClient();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  bool _submitted = false;

  String? get _errorText {
    final phone = _phone.value.text;
    if (phone.isEmpty) {
      return 'Nomor HP wajib diisi';
    } else if (phone.length < 5) {
      return 'Nomor HP tidak valid';
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

    var alertStyle1 = const AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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

  void changeValue1(bool? value) {
    setState(() {
      value1 = value!;
    });
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
                            child: Text('Buat daftar ke akun Preg-Fit kamu.',
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
                              debugPrint(_errorText);
                              setState(() => _submitted = true);
                              if (_errorText == null) {
                                if (_phone.value.text.isNotEmpty) {
                                  var res = await apiController.checkNO(_phone.text);
                                  if(mounted){
                                    if (res == 200) {
                                      _alertPertama(context);
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
                                    } else {
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

  void _alertPertama(BuildContext context){
    Alert(
        context: context,
        style: alertStyle1,
        title:
            'Apakah mom sudah mendapatkan izin dari dokter untuk melakukan senam yoga ibu hamil?',
        content: StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setState) {
            return Column(
              children: [
                const SizedBox(height: 10,),
                Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: DialogButton(
                        onPressed: () {
                            _alertKedua(context);
                        },
                        radius: const BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue,
                        child: const Text(
                          'Sudah',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: DialogButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatBot(
                                    phoneNo: _phone
                                        .value.text,
                                    aksi: 1),
                          ),
                        );
                      },
                      color: Colors.white,
                      radius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.blue),
                      child: const Text(
                        'Belum',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20),
                      ),
                    ),
                  )
                    ],
                  )
              ],
            );
          },
        ),
        buttons: []
      ).show();
  }

  void _alertKedua(BuildContext context){
      Alert(
                              context: context,
                              style: alertStyle,
                              title:
                                  'Sebelum mendaftar mom perlu menyetujui pernyataan dibawah ini',
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Column(
                                    children: [
                                      CheckboxListTile(
                                        dense: true,
                                        activeColor: Colors.blue,
                                        contentPadding:
                                            EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity
                                                .leading,
                                        title: Text(
                                          'Saya sudah konsultasi dan mendapatkan izin dari dokter kandungan',
                                          style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                          ),
                                        ),
                                        value: value1,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            value1 = value!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        dense: true,
                                        activeColor: Colors.blue,
                                        contentPadding:
                                            EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity
                                                .leading,
                                        title: Text(
                                          'Saya tidak mempunyai riwayat flek/pendarahan selama kehamilan',
                                          style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                          ),
                                        ),
                                        value: value2,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            value2 = value!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        dense: true,
                                        activeColor: Colors.blue,
                                        contentPadding:
                                            EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity
                                                .leading,
                                        title: Text(
                                          'Saya tidak mengalami kondisi plasenta Previa (plasenta menutupi jalan lahir)',
                                          style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                          ),
                                        ),
                                        value: value3,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            value3 = value!;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        dense: true,
                                        activeColor: Colors.blue,
                                        contentPadding:
                                            EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity
                                                .leading,
                                        title: Text(
                                          'Saya tidak memiliki penyakit khusus',
                                          style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                          ),
                                        ),
                                        value: value4,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            value4 = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    if (value1 &&
                                        value2 &&
                                        value3 &&
                                        value4) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OTP(
                                                  phoneNo: _phone
                                                      .value.text,
                                                  aksi: 1, email: '',),
                                        ),
                                      );
                                    }
                                  },
                                  color: Colors.blue,
                                  child: const Text(
                                    'LANJUT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            ).show();
                        
  }
}
