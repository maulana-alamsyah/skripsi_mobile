import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:pregfit/Screens/Onboarding/onboarding.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'
    as keyboard;
import 'package:dropdown_textfield/dropdown_textfield.dart';

class UbahProfil extends StatefulWidget {
  const UbahProfil({super.key});

  @override
  State<UbahProfil> createState() => _UbahProfilState();
}

class _UbahProfilState extends State<UbahProfil> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  late SingleValueDropDownController _cnt;
  bool _submitted = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;

  DateTime? selectedDate;
  late String dropdownValue;

  final List<DropDownValueModel> _list = [
    const DropDownValueModel(name: '0-4 Bulan', value: "0-4 Bulan"),
    const DropDownValueModel(
      name: '5-6 Bulan',
      value: "5-6 Bulan",
    ),
    const DropDownValueModel(name: '7-9 Bulan', value: "7-9 Bulan"),
  ];

  final client = HttpClient();

  String? get _errorTextNama {
    final nama = _controllerName.value.text.trim();
    if (nama.isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  }

  String? get _errorTextUsiaKandungan {
    final usiaKandungan = _cnt.dropDownValue?.value;
    if (usiaKandungan == null) {
      return 'Usia kandungan wajib diisi';
    }
    return null;
  }

  String? get _errorTextEmail {
    final email = _controllerEmail.value.text.trim();
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
        keyboard.KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
    _cnt = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _cnt.dispose();
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  Future<dynamic> getUser() async {
    // var token = box.read('token');
    var token = "test";
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 401) {
        // _signOut();
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const Onboarding()));
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

  Future<dynamic> updateUser(
      String nama, String tanggal, String usiaKandungan, String email) async {
    if (usiaKandungan == 'null') {
      usiaKandungan = '0-4 Bulan';
    }
    // var token = box.read('token');
    var token = "test";

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String no_hp = decodedToken['no_hp'];
    print(json.encode({
      'no_hp': no_hp,
      'email': email,
      'nama': nama,
      'usia_kandungan': usiaKandungan,
      'tanggal_lahir': tanggal
    }));

    try {
      final request =
          await client.putUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      if (usiaKandungan != 'null') {
        print('this if');
        final requestBodyBytes = utf8.encode(json.encode({
          'no_hp': no_hp,
          'email': email,
          'nama': nama,
          'usia_kandungan': usiaKandungan,
          'tanggal_lahir': tanggal
        }));

        request.headers
            .set('Content-Length', requestBodyBytes.length.toString());
        request.write(json.encode({
          'no_hp': no_hp,
          'email': email,
          'nama': nama,
          'usia_kandungan': usiaKandungan,
          'tanggal_lahir': tanggal
        }));
      } else {
        print('this else');
        final requestBodyBytes = json.encode({
          'no_hp': no_hp,
          'email': email,
          'nama': nama,
          'usia_kandungan': 'null',
          'tanggal_lahir': tanggal
        });

        request.headers
            .set('Content-Length', requestBodyBytes.length.toString());
        request.write(json.encode({
          'no_hp': no_hp,
          'email': email,
          'nama': nama,
          'usia_kandungan': 'null',
          'tanggal_lahir': tanggal
        }));
      }

      final response = await request.close();

      if (response.statusCode == 200) {
        return jsonDecode(await response.transform(utf8.decoder).join());
      } else if (response.statusCode == 401) {
        // _signOut();
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => const Onboarding()));
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

  void _updateController(String value) {
    setState(() {
      _cnt = SingleValueDropDownController(
          data: DropDownValueModel(name: value, value: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controllerName.text = _controllerName.text.isEmpty
                ? (snapshot.data['nama'] ?? '')
                : _controllerName.text;
            _controllerEmail.text = _controllerEmail.text.isEmpty
                ? (snapshot.data['email'] ?? '')
                : _controllerEmail.text;

            if (snapshot.data!['usia_kandungan'] != null &&
                snapshot.data!['usia_kandungan'] != 'null' &&
                snapshot.data!['usia_kandungan'].isNotEmpty) {
              dropdownValue = snapshot.data!['usia_kandungan'];
            }

            _updateController(dropdownValue);

            return WillPopScope(
                onWillPop: () => _onWillPop(snapshot.data),
                child: Scaffold(
                    appBar: AppBar(
                        toolbarHeight: Adaptive.h(8.7),
                        title: const Text('Ubah Profil',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22)),
                        titleSpacing: 5,
                        elevation: 2,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: true,
                        iconTheme: const IconThemeData(
                          color: Colors.black,
                        )),
                    body: Center(
                      child: SizedBox(
                        width: Adaptive.w(90),
                        child: Column(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: isKeyboardVisible
                                  ? BoxConstraints(
                                      maxHeight: Adaptive.h(45),
                                      minHeight: Adaptive.h(45),
                                    )
                                  : const BoxConstraints(),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  SizedBox(
                                    height: Adaptive.h(1),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Nama                                                     ',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: _controllerName,
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Nama Anda',
                                      errorText:
                                          _submitted ? _errorTextNama : null,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: Adaptive.h(2)),
                                      prefix: Padding(
                                          padding: EdgeInsets.only(
                                              left: Adaptive.h(2))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(2),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Tanggal Lahir                                         ',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  DateTimeField(
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                    initialPickerDateTime: selectedDate ??
                                        (snapshot.data['tanggal_lahir'] != null
                                            ? DateTime.tryParse(
                                                snapshot.data['tanggal_lahir'])
                                            : DateTime.now()),
                                    dateFormat: DateFormat('dd/MM/yyyy'),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Tanggal',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.all(Adaptive.h(2)),
                                    ),
                                    mode: DateTimeFieldPickerMode.date,
                                    value: selectedDate ?? DateTime.now(),
                                    onChanged: (DateTime? value) {
                                      setState(() {
                                        selectedDate = value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(2),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Usia Kandungan                                    ',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  DropDownTextField(
                                    controller: _cnt,
                                    dropDownList: _list,
                                    dropDownItemCount: 3,
                                    textStyle: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                    textFieldDecoration: InputDecoration(
                                      errorText: _submitted
                                          ? _errorTextUsiaKandungan
                                          : null,
                                      hintText: 'Usia Kandungan',
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: Adaptive.h(2)),
                                      prefix: Padding(
                                          padding: EdgeInsets.only(
                                              left: Adaptive.h(2))),
                                    ),
                                    clearOption: false,
                                    onChanged: (val) {
                                      setState(() {
                                        dropdownValue = val.value;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(2),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Email                                                      ',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    controller: _controllerEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                    ),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Email Anda',
                                      errorText:
                                          _submitted ? _errorTextEmail : null,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: Adaptive.h(2)),
                                      prefix: Padding(
                                          padding: EdgeInsets.only(
                                              left: Adaptive.h(2))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isKeyboardVisible == false,
                              replacement: const SizedBox(),
                              child: Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: EasyButton(
                                    type: EasyButtonType.elevated,
                                    onPressed: () {
                                      setState(() => _submitted = true);
                                      Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        style: alertStyle,
                                        title: 'Warning',
                                        desc: "Mau simpan perubahan mom?",
                                        buttons: [
                                          DialogButton(
                                            onPressed: () async {
                                              setState(() => _submitted = true);
                                              try {
                                                if (_errorTextNama == null &&
                                                    _errorTextEmail == null &&
                                                    _errorTextUsiaKandungan ==
                                                        null &&
                                                    dropdownValue != null &&
                                                    _controllerName.value.text
                                                        .isNotEmpty &&
                                                    _controllerEmail.value.text
                                                        .isNotEmpty &&
                                                    dropdownValue!.isNotEmpty) {
                                                  await updateUser(
                                                      _controllerName.text,
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(selectedDate !=
                                                                  null
                                                              ? selectedDate!
                                                              : (snapshot.data['tanggal_lahir'] !=
                                                                      null
                                                                  ? DateTime.tryParse(snapshot.data['tanggal_lahir']) ??
                                                                      DateTime
                                                                          .now()
                                                                  : DateTime
                                                                      .now())),
                                                      dropdownValue != null &&
                                                              dropdownValue!
                                                                  .isNotEmpty
                                                          ? dropdownValue
                                                          : ((snapshot.data['usia_kandungan'] !=
                                                                      null &&
                                                                  snapshot.data[
                                                                          'usia_kandungan'] !=
                                                                      'null' &&
                                                                  snapshot
                                                                      .data['usia_kandungan']
                                                                      .isNotEmpty)
                                                              ? snapshot.data['usia_kandungan']
                                                              : '0-4 Bulan'),
                                                      _controllerEmail.text);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Menu(
                                                                index: 3,
                                                              )));
                                                } else {
                                                  return;
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.error,
                                                    style: alertStyle,
                                                    title: 'Error',
                                                    desc:
                                                        "Tidak dapat terhubung dengan server",
                                                    buttons: [
                                                      DialogButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        color: Colors.blue,
                                                        child: const Text(
                                                          "Oke",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                      )
                                                    ],
                                                  ).show();
                                                }
                                              }
                                            },
                                            color: Colors.blue,
                                            child: const Text(
                                              "YA",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          DialogButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Menu(
                                                            index: 3,
                                                          )));
                                            },
                                            color: Colors.red,
                                            child: const Text(
                                              "TIDAK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ).show();
                                    },
                                    loadingStateWidget:
                                        const CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                    useEqualLoadingStateWidgetDimension: true,
                                    useWidthAnimation: true,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    borderRadius: 20,
                                    buttonColor: Colors.blue,
                                    contentGap: 6.0,
                                    idleStateWidget: Text(
                                      'Simpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: 'DMSans',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Adaptive.h(2.5),
                            ),
                          ],
                        ),
                      ),
                    )));
          } else {
            return keyboard.KeyboardVisibilityBuilder(
                builder: (BuildContext context, bool isKeyboardVisible) {
              return WillPopScope(
                  onWillPop: () => _onWillPop(snapshot.data),
                  child: Scaffold(
                      appBar: AppBar(
                          toolbarHeight: Adaptive.h(8.7),
                          title: const Text('Ubah Profil',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 22)),
                          titleSpacing: 5,
                          elevation: 2,
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: true,
                          iconTheme: const IconThemeData(
                            color: Colors.black,
                          )),
                      body: Center(
                        child: SizedBox(
                          width: Adaptive.w(90),
                          child: Column(
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: isKeyboardVisible
                                    ? BoxConstraints(
                                        maxHeight: Adaptive.h(45),
                                        minHeight: Adaptive.h(45),
                                      )
                                    : const BoxConstraints(),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    SizedBox(
                                      height: Adaptive.h(1),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Nama                                                     ',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: _controllerName,
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText: 'Nama Anda',
                                        errorText:
                                            _submitted ? _errorTextNama : null,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: Adaptive.h(2)),
                                        prefix: Padding(
                                            padding: EdgeInsets.only(
                                                left: Adaptive.h(2))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(2),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Tanggal Lahir                                         ',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    DateTimeField(
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                        initialPickerDateTime: selectedDate ??
                                            (snapshot.data != null &&
                                                    snapshot.data[
                                                            'tanggal_lahir'] !=
                                                        null
                                                ? DateTime.tryParse(snapshot
                                                    .data['tanggal_lahir'])
                                                : DateTime.now()),
                                        dateFormat: DateFormat('dd/MM/yyyy'),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Tanggal',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.all(Adaptive.h(2)),
                                        ),
                                        value: selectedDate ?? DateTime.now(),
                                        mode: DateTimeFieldPickerMode.date,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDate = value;
                                          });
                                        }),
                                    SizedBox(
                                      height: Adaptive.h(2),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Usia Kandungan                                    ',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    DropDownTextField(
                                      controller: _cnt,
                                      dropDownList: _list,
                                      dropDownItemCount: 3,
                                      textStyle: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                      textFieldDecoration: InputDecoration(
                                        errorText: _submitted
                                            ? _errorTextUsiaKandungan
                                            : null,
                                        hintText: 'Usia Kandungan',
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: Adaptive.h(2)),
                                        prefix: Padding(
                                            padding: EdgeInsets.only(
                                                left: Adaptive.h(2))),
                                      ),
                                      clearOption: false,
                                      onChanged: (val) {
                                        setState(() {
                                          dropdownValue = val.value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: Adaptive.h(2),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Email                                                      ',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _controllerEmail,
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText: 'Email Anda',
                                        errorText:
                                            _submitted ? _errorTextEmail : null,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: Adaptive.h(2)),
                                        prefix: Padding(
                                            padding: EdgeInsets.only(
                                                left: Adaptive.h(2))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isKeyboardVisible == false,
                                replacement: const SizedBox(),
                                child: Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: EasyButton(
                                      type: EasyButtonType.elevated,
                                      onPressed: () {
                                        setState(() => _submitted = true);
                                        if (mounted) {
                                          Alert(
                                            context: context,
                                            type: AlertType.error,
                                            style: alertStyle,
                                            title: 'Error',
                                            desc:
                                                "Tidak dapat terhubung dengan server",
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
                                      },
                                      loadingStateWidget:
                                          const CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                      useEqualLoadingStateWidgetDimension: true,
                                      useWidthAnimation: true,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      borderRadius: 20,
                                      buttonColor: Colors.blue,
                                      contentGap: 6.0,
                                      idleStateWidget: Text(
                                        'SIMPAN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontFamily: 'DMSans',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Adaptive.h(2.5),
                              ),
                            ],
                          ),
                        ),
                      )));
            });
          }
        });
  }

  Future<bool> _onWillPop(dynamic snapshotData) async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          style: alertStyle,
          title: 'Warning',
          desc: "Mau simpan perubahan mom?",
          buttons: [
            DialogButton(
              onPressed: () async {
                setState(() => _submitted = true);
                try {
                  if (_errorTextNama == null &&
                      _errorTextEmail == null &&
                      _errorTextUsiaKandungan == null &&
                      dropdownValue != null &&
                      _controllerName.value.text.isNotEmpty &&
                      _controllerEmail.value.text.isNotEmpty &&
                      dropdownValue!.isNotEmpty) {
                    await updateUser(
                        _controllerName.text,
                        DateFormat('dd/MM/yyyy').format(selectedDate != null
                            ? selectedDate!
                            : (snapshotData['tanggal_lahir'] != null
                                ? DateTime.tryParse(
                                        snapshotData['tanggal_lahir']) ??
                                    DateTime.now()
                                : DateTime.now())),
                        dropdownValue != null && dropdownValue!.isNotEmpty
                            ? dropdownValue
                            : ((snapshotData['usia_kandungan'] != null &&
                                    snapshotData['usia_kandungan'] != 'null' &&
                                    snapshotData['usia_kandungan'].isNotEmpty)
                                ? snapshotData['usia_kandungan']
                                : '0-4 Bulan'),
                        _controllerEmail.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Menu(
                                  index: 3,
                                )));
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      style: alertStyle,
                      title: 'Warning',
                      desc: "Mohon isi data dengan lengkap.",
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
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
              },
              color: Colors.blue,
              child: const Text(
                "YA",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Menu(
                              index: 3,
                            )));
              },
              color: Colors.red,
              child: const Text(
                "TIDAK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show()) ??
        false;
  }
}
