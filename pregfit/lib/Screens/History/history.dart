import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Controller/api_controller.dart';
import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pie_chart/pie_chart.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int touchedIndex = -1;
  List? data;
  late List<dynamic> jsonData;
  late List<Map<String, dynamic>> apiResponse;
  APIController apiController = APIController();

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

  Future<dynamic> getHistory() async {
    // var token = box.read('token');
    var token = "test";
    try {
      final request =
          await client.getUrl(Uri.parse("${Config.baseURL}/api/history"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");

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
        debugPrint('Network error: ${e.message}');
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

  Future<bool> _onWillPop() async {
    return (await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Menu(index: 0))));
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'id');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  List<Color> colorList = [
    const Color.fromRGBO(202, 73, 140, 1),
    const Color.fromRGBO(230, 191, 206, 1),
    const Color.fromRGBO(144, 43, 107, 1),
  ];

  Color getColorForIndex(int index) {
    final colors = [
      const Color.fromRGBO(202, 73, 140, 1),
      const Color.fromRGBO(230, 191, 206, 1),
      const Color.fromRGBO(144, 43, 107, 1),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([apiController.getPopular(context), apiController.getHistory(context)]),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data![0] != null) {
            data = snapshot.data![1];
            var popular = snapshot.data![0];


            Map<String, double> dataMap = {};

            popular?.forEach((item) {
              String jenisYoga = item['jenis_yoga'];
              double popularityPercentage =
                  item['popularity_percentage'].toDouble();
              dataMap[jenisYoga] = popularityPercentage;
            });

            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                  appBar: AppBar(
                      toolbarHeight: Adaptive.h(8.7),
                      title: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Populer',
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
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: Adaptive.h(2),
                          ),
                          Container(
                            height: Adaptive.h(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PieChart(
                                      dataMap: dataMap,
                                      animationDuration:
                                          const Duration(milliseconds: 800),
                                      chartLegendSpacing: 0,
                                      chartRadius:
                                          MediaQuery.of(context).size.width /
                                              3.2,
                                      colorList: colorList,
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.disc,
                                      legendOptions: const LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.left,
                                        showLegends: true,
                                        legendShape: BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        chartValueStyle:
                                            TextStyle(color: Colors.white),
                                        showChartValueBackground: false,
                                        showChartValues: true,
                                        showChartValuesInPercentage: true,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(3),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: const SizedBox(
                              child: Text('History',
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 22)),
                            ),
                          ),
                          SizedBox(
                            height: Adaptive.h(1),
                          ),
                          Column(
                            children: data?.map((item) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          bottom: Adaptive.h(2)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: const Color.fromRGBO(
                                          130, 165, 255, 1),
                                      clipBehavior: Clip.hardEdge,
                                      shadowColor: Colors.black,
                                      child: Container(
                                        height: Adaptive.h(13),
                                        padding: EdgeInsets.only(
                                            top: Adaptive.w(3),
                                            bottom: Adaptive.w(3),
                                            left: Adaptive.w(4),
                                            right: Adaptive.w(4)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                item['waktu'] +
                                                    ' - ' +
                                                    formatDate(item['tanggal']),
                                                style: TextStyle(
                                                    fontFamily: 'DMSans',
                                                    color: Colors.white,
                                                    fontSize: 17.sp),
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                item['jenis_yoga'],
                                                style: TextStyle(
                                                    fontFamily: 'DMSans',
                                                    color: Colors.white,
                                                    fontSize: 17.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ],
                      ))),
            );
          } else {
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                  appBar: AppBar(
                      toolbarHeight: Adaptive.h(8.7),
                      title: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Populer',
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
                      child: ListView(clipBehavior: Clip.none, children: [
                        SizedBox(
                          height: Adaptive.h(2),
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: Adaptive.h(25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            )),
                        SizedBox(
                          height: Adaptive.h(3),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const SizedBox(
                            child: Text('History',
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22)),
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: Adaptive.h(1)),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ))),
                        Container(
                            margin: EdgeInsets.only(bottom: Adaptive.h(1)),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ))),
                        Container(
                            margin: EdgeInsets.only(bottom: Adaptive.h(1)),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ))),
                        Container(
                            margin: EdgeInsets.only(bottom: Adaptive.h(1)),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: Adaptive.h(13),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ))),
                      ]))),
            );
          }
        });
  }
}
