import 'dart:convert';
import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:pregfit/Screens/Pengingat/ubah_pengingat.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_loading_button/easy_loading_button.dart';

class Pengingat extends StatefulWidget {
  const Pengingat({super.key});

  @override
  State<Pengingat> createState() => _PengingatState();
}

class _PengingatState extends State<Pengingat> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerJam = TextEditingController();

  final List _pengingat = [
    {
      'name': 'Pengingat satu',
      'tanggal_pengingat': 'Senin 25 Maret 2024',
      'jam': '08:00'
    },
    {
      'name': 'Pengingat dua',
      'tanggal_pengingat': 'Selasa 25 Maret 2024',
      'jam': '09:00'
    },
    {
      'name': 'Pengingat tiga',
      'tanggal_pengingat': 'Rabu 25 Maret 2024',
      'jam': '10:00'
    },
    {
      'name': 'Pengingat empat',
      'tanggal_pengingat': 'Jumat 25 Maret 2024',
      'jam': '11:00'
    },
    {
      'name': 'Pengingat 1',
      'tanggal_pengingat': 'Senin 25 Maret 2024',
      'jam': '08:00'
    },
    {
      'name': 'Pengingat 1',
      'tanggal_pengingat': 'Senin 25 Maret 2024',
      'jam': '08:00'
    },
    {
      'name': 'Pengingat 1',
      'tanggal_pengingat': 'Senin 25 Maret 2024',
      'jam': '08:00'
    },
  ];

  DateTime? selectedDate;
  late ScrollController _controller;

  final client = HttpClient();

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Future<dynamic> updateUser(String nama, String tanggal, String jam) async {
    // var token = box.read('token');
    var token = "test";

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String no_hp = decodedToken['no_hp'];
    print(json.encode({
      'no_hp': no_hp,
      'jam': jam,
      'nama': nama,
      'tanggal_pengingat': tanggal
    }));

    try {
      final request =
          await client.putUrl(Uri.parse("${Config.baseURL}/api/users"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
      // if (usiaKandungan != 'null') {
      //   print('this if');
      // //   final requestBodyBytes = utf8.encode(json.encode({
      // //     'no_hp': no_hp,
      // //     'email': email,
      // //     'nama': nama,
      // //     'usia_kandungan': usiaKandungan,
      // //     'tanggal_pengingat': tanggal
      // //   }));

      //   request.headers
      //       .set('Content-Length', requestBodyBytes.length.toString());
      //   request.write(json.encode({
      //     'no_hp': no_hp,
      //     'email': email,
      //     'nama': nama,
      //     'usia_kandungan': usiaKandungan,
      //     'tanggal_pengingat': tanggal
      //   }));
      // } else {
      //   print('this else');
      //   final requestBodyBytes = json.encode({
      //     'no_hp': no_hp,
      //     'email': email,
      //     'nama': nama,
      //     'usia_kandungan': 'null',
      //     'tanggal_pengingat': tanggal
      //   });

      //   request.headers
      //       .set('Content-Length', requestBodyBytes.length.toString());
      //   request.write(json.encode({
      //     'no_hp': no_hp,
      //     'email': email,
      //     'nama': nama,
      //     'usia_kandungan': 'null',
      //     'tanggal_pengingat': tanggal
      //   }));
      // }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controllerName.text = _controllerName.text.isEmpty
                ? (snapshot.data['nama'] ?? '')
                : _controllerName.text;
            _controllerJam.text = _controllerJam.text.isEmpty
                ? (snapshot.data['jam'] ?? '')
                : _controllerJam.text;

            return Scaffold(
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
                    child: ListView(
                      children: [
                        SizedBox(
                          height: Adaptive.h(2),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Nama                                                     ',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: Adaptive.h(7),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: _controllerName,
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Nama Pengingat',
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.all(Adaptive.h(2)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(2),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Tanggal Lahir                                         ',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: Adaptive.h(7),
                                  child: DateTimeField(
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    initialPickerDateTime: selectedDate ??
                                        (snapshot.data['tanggal_pengingat'] !=
                                                null
                                            ? DateTime.tryParse(snapshot
                                                .data['tanggal_pengingat'])
                                            : DateTime.now()),
                                    dateFormat: DateFormat('dd/MM/yyyy'),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.all(Adaptive.h(2)),
                                    ),
                                    mode: DateTimeFieldPickerMode.date,
                                    value: selectedDate,
                                    onChanged: (DateTime? value) {
                                      setState(() {
                                        selectedDate = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(2),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Usia Kandungan                                    ',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(2),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Jam                                                      ',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: Adaptive.h(7),
                                  child: TextField(
                                    controller: _controllerJam,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: 'Jam Pengingat',
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.all(Adaptive.h(2)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Adaptive.h(5),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: const Text(
                                                'Mau simpan perubahan mom?',
                                                style: TextStyle(
                                                  fontFamily: 'DMSans',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            FractionallySizedBox(
                                              widthFactor: 0.4,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    var res = await updateUser(
                                                      _controllerName.text,
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(selectedDate ??
                                                              (snapshot.data[
                                                                          'tanggal_pengingat'] !=
                                                                      null
                                                                  ? DateTime.tryParse(
                                                                          snapshot.data[
                                                                              'tanggal_pengingat']) ??
                                                                      DateTime
                                                                          .now()
                                                                  : DateTime
                                                                      .now())),
                                                      _controllerJam.text,
                                                    );
                                                    print(res);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Menu(
                                                                index: 3),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    if (mounted) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/images/robot404.gif',
                                                                    width:
                                                                        Adaptive.h(
                                                                            10),
                                                                    height:
                                                                        Adaptive.h(
                                                                            10),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  const SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Tidak dapat terhubung dengan server",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
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
                                            FractionallySizedBox(
                                              widthFactor: 0.4,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red[400],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'TIDAK',
                                                    style: TextStyle(
                                                      fontFamily: 'DMSans',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 130, vertical: 8),
                                    ),
                                    child: Text(
                                      'Simpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: 'DMSans',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                    toolbarHeight: Adaptive.h(8.7),
                    title: const Text('Pengingat',
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
                body: Stack(children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(4), right: Adaptive.w(4)),
                      alignment: Alignment.center,
                      child: ListView.builder(
                          itemCount: _pengingat.length,
                          itemBuilder: (context, index) {
                            final pengingat = _pengingat[index];
                            return index < _pengingat.length
                                ? Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UbahPengingat()));
                                          },
                                          child: SizedBox(
                                            height: Adaptive.h(15),
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.0)),
                                                color: const Color.fromRGBO(
                                                    130, 165, 255, 1),
                                                clipBehavior: Clip.hardEdge,
                                                child: Padding(
                                                    padding: EdgeInsets.all(
                                                        Adaptive.w(5)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 7,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: AutoSizeText(
                                                                        pengingat[
                                                                            'name'],
                                                                        maxLines:
                                                                            2,
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'DMSans',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 19))),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: AutoSizeText(
                                                                      pengingat[
                                                                          'tanggal_pengingat'],
                                                                      maxLines:
                                                                          2,
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              19)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: AutoSizeText(
                                                                pengingat[
                                                                    'jam'],
                                                                maxLines: 2,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'DMSans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        19)),
                                                          ),
                                                        )
                                                      ],
                                                    ))),
                                          )),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UbahPengingat()));
                                    },
                                    child: SizedBox(
                                      height: Adaptive.h(15),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22.0)),
                                          color: const Color.fromRGBO(
                                              130, 165, 255, 1),
                                          clipBehavior: Clip.hardEdge,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.all(Adaptive.w(5)),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 7,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: AutoSizeText(
                                                                  pengingat[
                                                                      'name'],
                                                                  maxLines: 2,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          19))),
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: AutoSizeText(
                                                                pengingat[
                                                                    'tanggal_pengingat'],
                                                                maxLines: 2,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'DMSans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        19)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: AutoSizeText(
                                                          pengingat['jam'],
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 19)),
                                                    ),
                                                  )
                                                ],
                                              ))),
                                    ));
                          })),
                  Positioned(
                    //display after the height of top widtet
                    bottom: 20,
                    right: 25,
                    //mention top, bottom, left, right, for full size widget
                    child: EasyButton(
                      type: EasyButtonType.elevated,
                      onPressed: () {
                        return;
                      },
                      width: 60,
                      height: 60,
                      borderRadius: 30.0,
                      loadingStateWidget: const CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                      useEqualLoadingStateWidgetDimension: true,
                      useWidthAnimation: true,
                      buttonColor: Colors.black,
                      contentGap: 6.0,
                      idleStateWidget: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]));
          }
        });
  }
}
