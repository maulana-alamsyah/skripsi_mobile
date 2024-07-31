import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/CustomIcons/custom_icons_icons.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:pregfit/Screens/Onboarding/onboarding.dart';
import 'package:pregfit/Screens/Pengingat/pengingat.dart';
import 'package:pregfit/Screens/Profil/Tentang/tentang.dart';
import 'package:pregfit/Screens/Profil/UbahProfil/ubah_profil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? _nama;
  String _noHp = "+628xxxxxxxxxx";
  String _trimester = "Trimester Pertama";
  APIController apiController = APIController();

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

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Menu(index: 0))));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiController.getUser(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _nama = snapshot.data['nama'] ?? 'Mom`s Preg-Fit';
            _noHp = snapshot.data['no_hp'];
            if (snapshot.data['usia_kandungan'] != null) {
              if (snapshot.data['usia_kandungan'] == '0-4 Bulan') {
                _trimester = 'Trimester Pertama';
              } else if (snapshot.data['usia_kandungan'] == '5-6 Bulan') {
                _trimester = 'Trimester Kedua';
              } else if (snapshot.data['usia_kandungan'] == '7-9 Bulan') {
                _trimester = 'Trimester Ketiga';
              } else {
                _trimester = 'Trimester Pertama';
              }
            } else {
              _trimester = 'Trimester Pertama';
            }

            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  appBar: AppBar(
                      toolbarHeight: Adaptive.h(8.7),
                      title: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Profil',
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
                  body: Container(
                    padding: EdgeInsets.only(
                        left: Adaptive.w(4), right: Adaptive.w(4)),
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: Adaptive.h(2),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  spreadRadius: 0,
                                  blurStyle: BlurStyle.normal),
                            ],
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: const Color.fromRGBO(130, 165, 255, 1),
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.black,
                            child: Container(
                                padding: EdgeInsets.all(Adaptive.h(1)),
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(Adaptive.h(2)),
                                        child: IntrinsicHeight(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Image.asset(
                                                    'assets/icons/profil_card.png')),
                                            SizedBox(
                                              width: Adaptive.w(3),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: double.infinity,
                                                      child: Text(_nama!,
                                                          maxLines: 2,
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'DMSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      20))),
                                                  SizedBox(
                                                      width: double.infinity,
                                                      child: Row(children: [
                                                        const Icon(
                                                            CustomIcons.phone,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(
                                                            width:
                                                                Adaptive.w(2)),
                                                        FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            _noHp,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ])),
                                                  SizedBox(
                                                      width: double.infinity,
                                                      child: Row(children: [
                                                        const Icon(
                                                            CustomIcons
                                                                .calendar,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(
                                                            width:
                                                                Adaptive.w(2)),
                                                        FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            _trimester,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'DMSans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ])),
                                                ],
                                              ),
                                            )
                                          ],
                                        ))),
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(3),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Selengkapnya',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),
                      Container(
                          height: Adaptive.h(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  spreadRadius: 0,
                                  blurStyle: BlurStyle.normal),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: const Color.fromRGBO(130, 165, 255, 1),
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(Adaptive.h(3)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UbahProfil()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.edit,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Ubah Profil',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const UbahProfil()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Pengingat()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: Image.asset(
                                                        'assets/icons/clock.png',
                                                      ),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Pengingat',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Pengingat()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Tentang()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.info,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text(
                                                        'Tentang Aplikasi',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Tentang()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Alert(
                                                context: context,
                                                style: const AlertStyle(
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    isCloseButton: false,
                                                    isOverlayTapDismiss: true,
                                                    descStyle: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    animationDuration: Duration(
                                                        milliseconds: 400),
                                                    alertBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    overlayColor:
                                                        Color(0x95000000),
                                                    alertElevation: 0,
                                                    alertAlignment:
                                                        Alignment.center),
                                                desc:
                                                    "\nMom yakin ingin keluar?\n Jangan lupa mampir ke Preg-Fit lagi ya :)",
                                                buttons: [
                                                  DialogButton(
                                                    onPressed: () async {
                                                      apiController.signOut();
                                                      SystemNavigator.pop();
                                                      Navigator.pushReplacement(
                                                        context, MaterialPageRoute(builder: (context) => const Onboarding()));
                                                    },
                                                    color: Colors.blue,
                                                    radius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'YA',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DialogButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    color: Colors.red,
                                                    radius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'TIDAK',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).show();
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.logout,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Keluar',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Alert(
                                                          context: context,
                                                          style:
                                                              const AlertStyle(
                                                                  animationType:
                                                                      AnimationType
                                                                          .fromTop,
                                                                  isCloseButton:
                                                                      false,
                                                                  isOverlayTapDismiss:
                                                                      true,
                                                                  descStyle: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  animationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              400),
                                                                  alertBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                    side:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  overlayColor:
                                                                      Color(
                                                                          0x95000000),
                                                                  alertElevation:
                                                                      0,
                                                                  alertAlignment:
                                                                      Alignment
                                                                          .center),
                                                          desc:
                                                              "\nMom yakin ingin keluar?\n Jangan lupa mampir ke Preg-Fit lagi ya :)",
                                                          buttons: [
                                                            DialogButton(
                                                              onPressed: () {
                                                                SystemNavigator
                                                                    .pop();
                                                              },
                                                              color:
                                                                  Colors.blue,
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'YA',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            DialogButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false);
                                                              },
                                                              color: Colors.red,
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'TIDAK',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ).show();
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(4),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: const Text('Version 2.0',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 21)),
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  appBar: AppBar(
                      toolbarHeight: Adaptive.h(8.7),
                      title: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Profil',
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
                  body: Container(
                    padding: EdgeInsets.only(
                        left: Adaptive.w(4), right: Adaptive.w(4)),
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: Adaptive.h(2),
                        ),
                        Container(
                          height: Adaptive.h(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  spreadRadius: 0,
                                  blurStyle: BlurStyle.normal),
                            ],
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: const Color.fromRGBO(130, 165, 255, 1),
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.black,
                            child: Container(
                                padding: EdgeInsets.all(Adaptive.h(1)),
                                child: Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(Adaptive.h(2)),
                                        child: IntrinsicHeight(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Image.asset(
                                                    'assets/icons/profil_card.png')),
                                            SizedBox(
                                              width: Adaptive.w(3),
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 150,
                                                          height: 20,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 150,
                                                          height: 20,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 150,
                                                          height: 20,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ))),
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(3),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Selengkapnya',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),
                        Container(
                          height: Adaptive.h(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  spreadRadius: 0,
                                  blurStyle: BlurStyle.normal),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: const Color.fromRGBO(130, 165, 255, 1),
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(Adaptive.h(3)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UbahProfil()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.edit,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Ubah Profil',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const UbahProfil()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Pengingat()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: Image.asset(
                                                        'assets/icons/clock.png',
                                                      ),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Pengingat',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Pengingat()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Tentang()));
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.info,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text(
                                                        'Tentang Aplikasi',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Tentang()));
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.3,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Alert(
                                                context: context,
                                                style: const AlertStyle(
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    isCloseButton: false,
                                                    isOverlayTapDismiss: true,
                                                    descStyle: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    animationDuration: Duration(
                                                        milliseconds: 400),
                                                    alertBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      side: BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    overlayColor:
                                                        Color(0x95000000),
                                                    alertElevation: 0,
                                                    alertAlignment:
                                                        Alignment.center),
                                                desc:
                                                    "\nMom yakin ingin keluar?\n Jangan lupa mampir ke Preg-Fit lagi ya :)",
                                                buttons: [
                                                  DialogButton(
                                                    onPressed: () {
                                                      SystemNavigator.pop();
                                                    },
                                                    color: Colors.blue,
                                                    radius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'YA',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DialogButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    color: Colors.red,
                                                    radius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 0),
                                                      child: Center(
                                                        child: Text(
                                                          'TIDAK',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).show();
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      height: Adaptive.h(3),
                                                      child: const Icon(
                                                          CustomIcons.logout,
                                                          color: Colors.white),
                                                    )),
                                                const Expanded(
                                                    flex: 8,
                                                    child: Text('Keluar',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'DMSans',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 17.5))),
                                                Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Alert(
                                                          context: context,
                                                          style:
                                                              const AlertStyle(
                                                                  animationType:
                                                                      AnimationType
                                                                          .fromTop,
                                                                  isCloseButton:
                                                                      false,
                                                                  isOverlayTapDismiss:
                                                                      true,
                                                                  descStyle: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  animationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              400),
                                                                  alertBorder:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                    side:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  overlayColor:
                                                                      Color(
                                                                          0x95000000),
                                                                  alertElevation:
                                                                      0,
                                                                  alertAlignment:
                                                                      Alignment
                                                                          .center),
                                                          desc:
                                                              "\nMom yakin ingin keluar?\n Jangan lupa mampir ke Preg-Fit lagi ya :)",
                                                          buttons: [
                                                            DialogButton(
                                                              onPressed: () {
                                                                SystemNavigator
                                                                    .pop();
                                                              },
                                                              color:
                                                                  Colors.blue,
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'YA',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            DialogButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false);
                                                              },
                                                              color: Colors.red,
                                                              radius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'TIDAK',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'DMSans',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ).show();
                                                      },
                                                      icon: Image.asset(
                                                        'assets/icons/arrow.png',
                                                      ),
                                                      iconSize: Adaptive.h(3),
                                                    )),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 15),
                          alignment: Alignment.bottomCenter,
                          child: const Text('Version 2.0',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 21)
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }
        });
  }
}
