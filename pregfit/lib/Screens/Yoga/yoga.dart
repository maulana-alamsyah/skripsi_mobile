import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pregfit/Screens/Camera/camera.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/Onboarding/onboarding.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';

class Yoga extends StatefulWidget {
  const Yoga({super.key});

  @override
  State<Yoga> createState() => _YogaState();
}

class _YogaState extends State<Yoga> {
  int trimester = 0;
  List<String> allowedPoses = [];
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

  @override
  void initState() {
    super.initState();
  }

  void initializeYogaPoses(int selectedTrimester) {
    trimester = selectedTrimester;

    // Determine allowed poses based on the selected trimester
    if (trimester == 1) {
      allowedPoses = ['Side Bend Pose', 'Child Pose'];
    } else if (trimester == 2) {
      allowedPoses = [
        'Side Bend Pose',
        'Cat Cow Pose',
        'Child Pose',
        'Side Clamp Pose',
        'Lateral Leg Raise Pose'
      ];
    } else if (trimester == 3) {
      allowedPoses = [
        'Side Bend Pose',
        'Cat Cow Pose',
        'Child Pose',
        'Side Clamp Pose',
        'Lateral Leg Raise Pose',
        'Savasana Pose'
      ];
    }
  }

  bool isPoseAllowed(String poseName) {
    return allowedPoses.contains(poseName);
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
    return (await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Menu(index: 0))));
  }

  Future<dynamic> showChoice(String jenisYoga) async {
    try {
      await addHistory(jenisYoga);
      await availableCameras().then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Camera(
                    cameras: value,
                    jenisYoga: jenisYoga,
                  ))));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['usia_kandungan'] == "0-4 Bulan") {
              trimester = 1;
            } else if (snapshot.data['usia_kandungan'] == "5-6 Bulan") {
              trimester = 2;
            } else if (snapshot.data['usia_kandungan'] == "7-9 Bulan") {
              trimester = 3;
            } else {
              trimester = 1;
            }
            print(trimester);
            initializeYogaPoses(trimester);
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  body: Container(
                      padding: EdgeInsets.only(
                          top: Adaptive.h(3),
                          left: Adaptive.w(4),
                          right: Adaptive.w(4)),
                      alignment: Alignment.center,
                      child: ListView(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Ayo mom!',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(1),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Pilih gerakan senam',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(5),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (isPoseAllowed("Cat Cow Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice(
                                                          "Cat Cow Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Cat Cow Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(2)),
                                                    child: Image.asset(
                                                        'assets/icons/cat_cow_pose.png',
                                                        fit: BoxFit.fill)))
                                          ],
                                        ))),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (isPoseAllowed("Child Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice("Child Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Child Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(2)),
                                                    child: Image.asset(
                                                        'assets/icons/child_pose.png',
                                                        fit: BoxFit.fill)))
                                          ],
                                        ))),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (isPoseAllowed("Lateral Leg Raise Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice(
                                                          "Lateral Leg Raise Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Lateral Leg Raise Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(2)),
                                                    child: Image.asset(
                                                        'assets/icons/lateral_leg_raise.png',
                                                        fit: BoxFit.fill)))
                                          ],
                                        ))),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (isPoseAllowed("Side Clamp Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice(
                                                          "Side Clamp Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Side Clamp Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(2)),
                                                    child: Image.asset(
                                                        'assets/icons/sideclamp.png',
                                                        fit: BoxFit.fill)))
                                          ],
                                        ))),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (isPoseAllowed("Side Bend Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice(
                                                          "Side Bend Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Side Bend Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(1)),
                                                    child: Image.asset(
                                                        'assets/icons/sideband.png',
                                                        fit: BoxFit.contain)))
                                          ],
                                        ))),
                              )),
                          GestureDetector(
                              onTap: () async {
                                if (isPoseAllowed("Savasana Pose")) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: const Text(
                                                  '''Apabila selama mengikuti gerakan yoga perut mom mengalami kram atau kontraksi segera hentikan yoga.''',
                                                  style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      showChoice(
                                                          "Savasana Pose");
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Center(
                                                child: Text('Peringatan!')),
                                            content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  '''Maaf yoga ini tidak dapat dilakukan oleh ibu hamil trimester $trimester.''',
                                                  style: const TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              FractionallySizedBox(
                                                  widthFactor: 0.4,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))));
                                      });
                                }
                              },
                              child: SizedBox(
                                height: Adaptive.h(20),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0)),
                                    color:
                                        const Color.fromRGBO(130, 165, 255, 1),
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AutoSizeText(
                                                        'Savasana Pose',
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 15)),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: SizedBox(
                                                        child: Image.asset(
                                                            'assets/icons/waktu.png',
                                                            color: Colors.black,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 6,
                                                child: Container(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.h(2)),
                                                    child: Image.asset(
                                                        'assets/icons/savasana.png',
                                                        fit: BoxFit.fill)))
                                          ],
                                        ))),
                              )),
                        ],
                      )),
                ));
          } else {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  body: Container(
                      padding: EdgeInsets.only(
                          top: Adaptive.h(3),
                          left: Adaptive.w(4),
                          right: Adaptive.w(4)),
                      alignment: Alignment.center,
                      child: ListView(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Ayo mom!',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(1),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Pilih gerakan senam',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(5),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.white,
                              clipBehavior: Clip.hardEdge,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ));
          }
        });
  }
}
