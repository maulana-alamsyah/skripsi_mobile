import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pregfit/Screens/Pengingat/tambah_pengingat.dart';
import 'package:pregfit/Screens/Pengingat/ubah_pengingat.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shimmer/shimmer.dart';

class Pengingat extends StatefulWidget {
  const Pengingat({super.key});

  @override
  State<Pengingat> createState() => _PengingatState();
}

class _PengingatState extends State<Pengingat> {
  late Future<List<NotificationModel>>? _futureNotifications;
  List<NotificationModel> activeNotifications = [];

  DateTime? selectedDate;
  late ScrollController _controller;

  final client = HttpClient();

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    _futureNotifications = _fetchActiveNotifications();
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

  Future<List<NotificationModel>> _fetchActiveNotifications() async {
    List<NotificationModel> notifications =
        await AwesomeNotifications().listScheduledNotifications();
    setState(() {
      activeNotifications = notifications;
    });
    return notifications;
  }

  String getHourMinute(int? hour, int? minute) {
    String hourText =
        hour != null ? hour.toString().padLeft(2, '0') : 'Unknown';
    String minuteText =
        minute != null ? minute.toString().padLeft(2, '0') : 'Unknown';
    return '$hourText:$minuteText';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: Adaptive.h(8.7),
          title: const Text(
            'Pengingat',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          titleSpacing: 5,
          elevation: 2,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                alignment: Alignment.center,
                child: FutureBuilder<List<NotificationModel>>(
                    future: _futureNotifications,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildShimmer();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Belum ada pengingat'));
                      } else {
                        var _pengingat = activeNotifications.isNotEmpty
                            ? activeNotifications
                            : snapshot.data!;
                        return ListView.builder(
                          itemCount: _pengingat.length,
                          itemBuilder: (context, index) {
                            String time = 'Unknown';
                            String frekuensi = 'Harian';
                            String name = '';
                            NotificationModel pengingat = _pengingat[index];
                            int id = pengingat.content!.id!;
                            name = pengingat.content!.summary!;
                            if (pengingat.schedule is NotificationCalendar) {
                              NotificationCalendar schedule =
                                  pengingat.schedule as NotificationCalendar;
                              int? hour = schedule.hour;
                              int? minute = schedule.minute;
                              String formattedHour = hour != null
                                  ? hour.toString().padLeft(2, '0')
                                  : '00';
                              String formattedMinute = minute != null
                                  ? minute.toString().padLeft(2, '0')
                                  : '00';
                              time = '$formattedHour:$formattedMinute';

                              if (schedule.weekday != null &&
                                  schedule.weekday != 0) {
                                frekuensi = 'Mingguan';
                              }
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UbahPengingat(id: id)),
                                    );
                                    if (result != null) {
                                      List<NotificationModel>
                                          updatedNotifications =
                                          await _fetchActiveNotifications();
                                      setState(() {
                                        _futureNotifications =
                                            Future.value(updatedNotifications);
                                        activeNotifications =
                                            updatedNotifications;
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: Adaptive.h(15),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      color: const Color.fromRGBO(
                                          130, 165, 255, 1),
                                      clipBehavior: Clip.hardEdge,
                                      child: Padding(
                                        padding: EdgeInsets.all(Adaptive.w(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 7,
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
                                                    Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: AutoSizeText(
                                                        name,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          fontFamily: 'DMSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 19,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: AutoSizeText(
                                                        frekuensi,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          fontFamily: 'DMSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 19,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: AutoSizeText(
                                                  time,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    })),
            Positioned(
              bottom: 20,
              right: 25,
              child: _buildFloatingActionButton(),
            ),
          ],
        ));
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items to display
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: Adaptive.h(15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0),
              ),
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
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return EasyButton(
      type: EasyButtonType.elevated,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TambahPengingat()),
        );
        if (result != null) {
          List<NotificationModel> updatedNotifications =
              await _fetchActiveNotifications();
          setState(() {
            _futureNotifications = Future.value(updatedNotifications);
            activeNotifications = updatedNotifications;
          });
        }
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
    );
  }
}
