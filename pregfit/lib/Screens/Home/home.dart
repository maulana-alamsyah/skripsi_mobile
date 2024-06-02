import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/Camera/camera_trimester1.dart';
import 'package:pregfit/Screens/Camera/camera_trimester2.dart';
import 'package:pregfit/Screens/Camera/camera_trimester3.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _name = "Pilih Trimester";

  final client = HttpClient();

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

  Future<dynamic> checkToken() async {
    // var token = box.read('token');
    var token = "test";

    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/check_token"));
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

  Future<dynamic> addHistory(String jenisYoga) async {
    String waktu;
    if (jenisYoga == 'Trimester 1') {
      waktu = '2 Menit';
    } else if (jenisYoga == 'Trimester 2') {
      waktu = '4 Menit';
    } else {
      waktu = '6 Menit';
    }
    try {
      // var token = box.read('token');
      var token = "test";
      final tanggal = DateFormat("dd/MM/yyyy", "id_ID").format(DateTime.now());
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}:5000/api/history"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      final requestBodyBytes = utf8.encode(json.encode({
        'tanggal': tanggal,
        'waktu': waktu,
        'jenis_yoga': jenisYoga,
      }));
      print(json.encode({
        'tanggal': tanggal,
        'waktu': waktu,
        'jenis_yoga': jenisYoga,
      }));

      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({
        'tanggal': tanggal,
        'waktu': waktu,
        'jenis_yoga': jenisYoga,
      }));

      final response = await request.close();

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle the SocketException (e.g., display an error message)
        print('Network error: ${e.message}');
      } else {}
    }
  }

  Future<bool> _onWillPop() async {
    return (await Alert(
          context: context,
          style: const AlertStyle(
              animationType: AnimationType.fromTop,
              isCloseButton: false,
              isOverlayTapDismiss: true,
              descStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              animationDuration: Duration(milliseconds: 400),
              alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              overlayColor: Color(0x95000000),
              alertElevation: 0,
              alertAlignment: Alignment.center),
          desc:
              "\nMom yakin ingin keluar?\n Jangan lupa mampir ke Preg-Fit lagi ya :)",
          buttons: [
            DialogButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              color: Colors.blue,
              radius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(
                  child: Text(
                    'YA',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              color: Colors.red,
              radius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(
                  child: Text(
                    'TIDAK',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  _onWillPop();
                },
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                        toolbarHeight: Adaptive.h(8.7),
                        title: Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: const Text('Home',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22))),
                        titleSpacing: 5,
                        elevation: 2,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        iconTheme: const IconThemeData(
                          color: Colors.black,
                        )),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Adaptive.h(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                          ),
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                              minFontSize: 15,
                              maxFontSize: 20,
                              DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                  .format(DateTime.now()),
                              style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: Adaptive.w(5), right: Adaptive.w(5)),
                                child: Column(children: [
                                  const Spacer(flex: 2),
                                  SizedBox(
                                    width: double.infinity,
                                    height: Adaptive.h(35),
                                    child: Image.asset('assets/images/home.png',
                                        fit: BoxFit.fill),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sudahkah Mom siap melakukan Senam yoga ibu Hamil?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            blurRadius: 4.0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                  Column(
                                    children: [
                                      FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        content: const Text(
                                                          'Usia Kehamilan Mom',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester1Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 1';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20)),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 1',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester2Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 2';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            3),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 2',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester3Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 3';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            3),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 3',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30)))),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.only(
                                                    top: Adaptive.h(0.5),
                                                    bottom: Adaptive.w(0.5)),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Adaptive.w(5))),
                                                backgroundColor:
                                                    Colors.redAccent[100]),
                                            child: Text(_name,
                                                style: const TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                      SizedBox(
                                        height: Adaptive.h(1),
                                      ),
                                      FractionallySizedBox(
                                          widthFactor: 0.5,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (_name != "Pilih Trimester") {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          title: const Center(
                                                              child: Text(
                                                                  'Peringatan!')),
                                                          content: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              child: const Text(
                                                                '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'DMSans',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          actions: [
                                                            FractionallySizedBox(
                                                                widthFactor:
                                                                    0.4,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (_name ==
                                                                        'Trimester 1') {
                                                                      // await AddHistory(
                                                                      //     _name);
                                                                      await availableCameras().then((value) => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => CameraTrimester1(
                                                                                    cameras: value,
                                                                                    jenisYoga: _name,
                                                                                  ))));
                                                                    } else if (_name ==
                                                                        'Trimester 2') {
                                                                      // await AddHistory(
                                                                      //     _name);
                                                                      await availableCameras().then((value) => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => CameraTrimester2(
                                                                                    cameras: value,
                                                                                    jenisYoga: _name,
                                                                                  ))));
                                                                    } else if (_name ==
                                                                        'Trimester 3') {
                                                                      // await AddHistory(
                                                                      //     _name);
                                                                      await availableCameras().then((value) => Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => CameraTrimester3(
                                                                                    cameras: value,
                                                                                    jenisYoga: _name,
                                                                                  ))));
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20))),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'OK',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'DMSans',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontSize: 18),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)))),
                                                );
                                              } else {
                                                Alert(
                                                  context: context,
                                                  type: AlertType.warning,
                                                  style: alertStyle,
                                                  title: 'Warning',
                                                  desc:
                                                      "Silahkan pilih trimester dulu mom",
                                                  buttons: [
                                                    DialogButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
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
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.only(
                                                    top: Adaptive.h(0.5),
                                                    bottom: Adaptive.h(0.5)),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Adaptive.w(5))),
                                                backgroundColor: Colors.blue),
                                            child: const AutoSizeText(
                                              'Ayo mulai!',
                                              minFontSize: 20,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'DMSans',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ],
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                ]))),
                      ],
                    )));
          } else {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                        toolbarHeight: Adaptive.h(8.7),
                        title: Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: const Text('Home',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22))),
                        titleSpacing: 5,
                        elevation: 2,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        iconTheme: const IconThemeData(
                          color: Colors.black,
                        )),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Adaptive.h(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                          ),
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                              minFontSize: 15,
                              maxFontSize: 20,
                              DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                  .format(DateTime.now()),
                              style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: Adaptive.w(5), right: Adaptive.w(5)),
                                child: Column(children: [
                                  const Spacer(flex: 2),
                                  SizedBox(
                                    width: double.infinity,
                                    height: Adaptive.h(35),
                                    child: Image.asset('assets/images/home.png',
                                        fit: BoxFit.fill),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sudahkah Mom siap melakukan Senam yoga ibu Hamil?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            blurRadius: 4.0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                  Column(
                                    children: [
                                      FractionallySizedBox(
                                          widthFactor: 0.7,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        content: const Text(
                                                          'Usia Kehamilan Mom',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester1Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 1';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            3),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 1',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester2Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 2';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            3),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 2',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Alert(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        const Trimester3Popup(),
                                                                    buttons: [],
                                                                  ).show();
                                                                  setState(() {
                                                                    _name =
                                                                        'Trimester 3';
                                                                  });
                                                                },
                                                                style: TextButton.styleFrom(
                                                                    fixedSize:
                                                                        const Size(
                                                                            150,
                                                                            40),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            20)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0,
                                                                        vertical:
                                                                            3),
                                                                    backgroundColor:
                                                                        Colors.redAccent[
                                                                            100]),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Trimester 3',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30)))),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.only(
                                                    top: Adaptive.h(0.5),
                                                    bottom: Adaptive.w(0.5)),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Adaptive.w(5))),
                                                backgroundColor:
                                                    Colors.redAccent[100]),
                                            child: Text(_name,
                                                style: const TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                      SizedBox(
                                        height: Adaptive.h(1),
                                      ),
                                      FractionallySizedBox(
                                          widthFactor: 0.5,
                                          child: ElevatedButton(
                                            onPressed: () async {},
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.only(
                                                    top: Adaptive.h(0.5),
                                                    bottom: Adaptive.h(0.5)),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Adaptive.w(5))),
                                                backgroundColor: Colors.blue),
                                            child: const AutoSizeText(
                                              'Ayo mulai!',
                                              minFontSize: 20,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'DMSans',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ],
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                ]))),
                      ],
                    )));
          }
        });
  }
}

class Trimester1Popup extends StatelessWidget {
  const Trimester1Popup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Panduan Trimester 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                '1. Side Bend Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Duduk dengan kaki bersilah bisa juga merenggangkan kaki, apabila kaki kanan di buka dan kaki kiri ditutup, miringkan badan kekiri kemudian tangan kiri menyentuh kaki kiri dan tarik tangan kanan miring ke kiri. Lakukan hal yang sama apa bila berbeda arah. Apabila kaki tidak diregangkan, cukup miring ke kanan dan tangan kanan miring ke kanan, begitu sebaliknya.',
              ),
            ),
            const ListTile(
              title: Text(
                '2. Child Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Buka kedua paha untuk space perut, untuk posisi bayi yang masih sungsang, dianjurkan pantatnya diangkat lebih tinggi. Tempelkan kepala ke matras.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Mengerti'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Trimester2Popup extends StatelessWidget {
  const Trimester2Popup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Panduan Trimester 2',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                '1. Side Bend Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Duduk dengan kaki bersilah bisa juga merenggangkan kaki, apabila kaki kanan di buka dan kaki kiri ditutup, miringkan badan kekiri kemudian tangan kiri menyentuh kaki kiri dan tarik tangan kanan miring ke kiri. Lakukan hal yang sama apa bila berbeda arah. Apabila kaki tidak diregangkan, cukup miring ke kanan dan tangan kanan miring ke kanan, begitu sebaliknya.',
              ),
            ),
            const ListTile(
              title: Text(
                '2. Cat Cow Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Jari jari tangan terbuka lebar, punggung dan telapak tangan sejajar, buka kedua tangan selebar bahu, ketika tarik nafas padangan kepala ke atas lengkungkan punggung kebawah. buang nafas ketika pandangan ke perut lengkungkan punggung ke atas tulang ekor masuk.',
              ),
            ),
            const ListTile(
              title: Text(
                '3. Side Clamp Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Badan miring ke kanan, tangan kanan lurus ke atas, tetkuk tumit lalu buka kaki kiri keatas dan tutup kaki kiri kebawah. lakukan bergantian dengan memiringkan badan kekiri dan lakukan hal yang sama.',
              ),
            ),
            const ListTile(
              title: Text(
                '4. Lateral Leg Raise Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Memiringkan badan, lalu angkat kaki ke atas, saat kaki diatas tarik nafas, saat kaki dibawah buang nafas. gerakan ini dilakukan bergantian saat miring ke kanan maka kaki kiri diatas, setelah selesai gantian miring ke kiri maka kaki kanan diatas.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Mengerti'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Trimester3Popup extends StatelessWidget {
  const Trimester3Popup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Panduan Trimester 3',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              title: Text(
                '1. Side Bend Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Duduk dengan kaki bersilah bisa juga merenggangkan kaki, apabila kaki kanan di buka dan kaki kiri ditutup, miringkan badan kekiri kemudian tangan kiri menyentuh kaki kiri dan tarik tangan kanan miring ke kiri. Lakukan hal yang sama apa bila berbeda arah. Apabila kaki tidak diregangkan, cukup miring ke kanan dan tangan kanan miring ke kanan, begitu sebaliknya.',
              ),
            ),
            const ListTile(
              title: Text(
                '2. Cat Cow Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Jari jari tangan terbuka lebar, punggung dan telapak tangan sejajar, buka kedua tangan selebar bahu, ketika tarik nafas padangan kepala ke atas lengkungkan punggung kebawah. buang nafas ketika pandangan ke perut lengkungkan punggung ke atas tulang ekor masuk.',
              ),
            ),
            const ListTile(
              title: Text(
                '3. Child Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Buka kedua paha untuk space perut, untuk posisi bayi yang masih sungsang, dianjurkan pantatnya diangkat lebih tinggi. Tempelkan kepala ke matras.',
              ),
            ),
            const ListTile(
              title: Text(
                '4. Side Clamp Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Badan miring ke kanan, tangan kanan lurus ke atas, tetkuk tumit lalu buka kaki kiri keatas dan tutup kaki kiri kebawah. lakukan bergantian dengan memiringkan badan kekiri dan lakukan hal yang sama.',
              ),
            ),
            const ListTile(
              title: Text(
                '5. Lateral Leg Raise Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Memiringkan badan, lalu angkat kaki ke atas, saat kaki diatas tarik nafas, saat kaki dibawah buang nafas. gerakan ini dilakukan bergantian saat miring ke kanan maka kaki kiri diatas, setelah selesai gantian miring ke kiri maka kaki kanan diatas.',
              ),
            ),
            const ListTile(
              title: Text(
                '6. Savasana Pose',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Siapkan bantal terlebih dahulu untuk diapit dua kaki. Posisi badan miring kanan atau kiri, dan bantal tersebut diapit. Bisa dilakukan dengan dua gerakan, posisi tidur terlentang atau miring ke arah kanan atau kiri',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Mengerti'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
