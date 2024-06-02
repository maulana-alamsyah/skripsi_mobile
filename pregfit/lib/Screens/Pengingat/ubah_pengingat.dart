// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregfit/Controller/notification_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'
    as keyboard;

class UbahPengingat extends StatefulWidget {
  final int id;
  const UbahPengingat({super.key, required this.id});

  @override
  State<UbahPengingat> createState() => _UbahPengingatState();
}

class _UbahPengingatState extends State<UbahPengingat> {
  final TextEditingController _controllerName = TextEditingController();
  bool _submitted = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  late SingleValueDropDownController _cnt;
  late NotificationModel notification;
  DateTime scheduledDateTime = DateTime.now();
  late String summary;
  late DropDownValueModel dropdownInitialValue =
      const DropDownValueModel(name: 'Harian', value: 'Harian');
  late String name = '';
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  DateTime? selectedDate;
  String? dropdownValue;

  final List<DropDownValueModel> _frekuensi = [
    const DropDownValueModel(name: 'Harian', value: "Harian"),
    const DropDownValueModel(
      name: 'Mingguan',
      value: "Mingguan",
    ),
  ];

  final client = HttpClient();

  String? get _errorTextNama {
    final nama = _controllerName.value.text.trim();
    if (nama.isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  }

  String? get _errorTextJam {
    final jam = _cnt.dropDownValue?.value.trim();
    if (jam == null || jam.isEmpty) {
      return 'Frekuensi wajib diisi';
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
    _controllerName.dispose();
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  Future<NotificationModel> _fetchActiveNotifications() async {
    List<NotificationModel> notifications =
        await AwesomeNotifications().listScheduledNotifications();

    for (NotificationModel notification in notifications) {
      if (notification.content?.id == widget.id) {
        return notification;
      }
    }

    return NotificationModel();
  }

  Future<dynamic> updateNotification(
      String nama, DateTime tanggal, String frekuensi) async {
    // var token = box.read('token');
    // var token = "test";
    // var id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    var weekday = tanggal.weekday;
    var hour = tanggal.hour;
    var minute = tanggal.minute;

    if (widget.id != 0) {
      try {
        await AwesomeNotifications().cancel(widget.id);
        if (frekuensi == 'Harian') {
          await NotificationController.createNewDailyReminder(
              id: widget.id, summary: nama, hour: hour, minute: minute);
        } else if (frekuensi == 'Mingguan') {
          await NotificationController.createNewWeeklyReminder(
              id: widget.id,
              summary: nama,
              weekday: weekday,
              hour: hour,
              minute: minute);
        }
      } catch (e) {
        if (e is SocketException) {
          // Handle the SocketException (e.g., display an error message)
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
  }

  Future<dynamic> deleteNotification() async {
    // var token = box.read('token');
    // var token = "test";
    // var id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    if (widget.id != 0) {
      try {
        await AwesomeNotifications().cancel(widget.id);
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
                  if (_formKey.currentState!.validate()) {
                    await updateNotification(
                        name, scheduledDateTime, dropdownInitialValue.value);
                    Navigator.pop(context);
                    Navigator.pop(context, true);
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
                            Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchActiveNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NotificationModel? notification = snapshot.data;
            if (!_initialized) {
              if (notification?.schedule != null) {
                NotificationCalendar schedule =
                    notification!.schedule as NotificationCalendar;

                int year = schedule.year ?? DateTime.now().year;
                int month = schedule.month ?? DateTime.now().month;
                int day = schedule.day ?? DateTime.now().day;
                int hour = schedule.hour ?? 0;
                int minute = schedule.minute ?? 0;
                int second = schedule.second ?? 0;

                scheduledDateTime =
                    DateTime(year, month, day, hour, minute, second);

                if (DateTime.now().isAfter(scheduledDateTime)) {
                  scheduledDateTime =
                      scheduledDateTime.add(const Duration(days: 1));
                }

                name = notification.content?.summary ?? '';

                if (schedule.weekday != null && schedule.weekday != 0) {
                  dropdownInitialValue = const DropDownValueModel(
                    name: 'Mingguan',
                    value: "Mingguan",
                  );
                } else {
                  dropdownInitialValue = const DropDownValueModel(
                    name: 'Harian',
                    value: "Harian",
                  );
                }
                // _initialized = true;
              } else {
                name = "";
                scheduledDateTime = DateTime.now();
              }
              _initialized = true;
            }
            return WillPopScope(
                onWillPop: () => _onWillPop(snapshot.data),
                child: Scaffold(
                    appBar: AppBar(
                        toolbarHeight: Adaptive.h(8.7),
                        title: const Text('Ubah Pengingat',
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ConstrainedBox(
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
                                      TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        initialValue: name,
                                        // controller: _controllerName,
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Nama pengingat harus diisi';
                                          } else if (value.length > 20) {
                                            return 'Maksimal 20 karakter';
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                          hintText: 'Nama Pengingat',
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
                                          'Tanggal',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      DateTimeFormField(
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: const Color(0xFF000000),
                                          fontSize: 16.sp,
                                        ),
                                        initialValue: scheduledDateTime,
                                        initialPickerDateTime:
                                            scheduledDateTime,
                                        dateFormat:
                                            DateFormat('dd/MM/yyyy HH:mm'),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.all(Adaptive.h(2)),
                                        ),
                                        mode:
                                            DateTimeFieldPickerMode.dateAndTime,
                                        onChanged: (DateTime? value) {
                                          setState(() {
                                            scheduledDateTime = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: Adaptive.h(2),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'Frekuensi',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      DropDownTextField(
                                        dropDownList: _frekuensi,
                                        initialValue:
                                            dropdownInitialValue.value,
                                        dropDownItemCount: 3,
                                        textStyle: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                        textFieldDecoration: InputDecoration(
                                          errorText: _submitted
                                              ? dropdownInitialValue.value
                                                      .toString()
                                                      .isEmpty
                                                  ? 'Frekuensi harus diisi'
                                                  : null
                                              : null,
                                          hintText: 'Frekuensi',
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
                                            dropdownInitialValue = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isKeyboardVisible == false,
                                replacement: const SizedBox(),
                                child: Column(children: [
                                  EasyButton(
                                    type: EasyButtonType.elevated,
                                    onPressed: () {
                                      setState(() => _submitted = true);
                                      if (_formKey.currentState!.validate()) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          style: alertStyle,
                                          title: 'Warning',
                                          desc: "Mau hapus pengingat mom?",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                try {
                                                  await deleteNotification();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, true);
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
                                                                color: Colors
                                                                    .white,
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
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                      } else {
                                        return;
                                      }
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
                                    buttonColor: Colors.red.shade400,
                                    contentGap: 6.0,
                                    idleStateWidget: Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: 'DMSans',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(1.5),
                                  ),
                                  EasyButton(
                                    type: EasyButtonType.elevated,
                                    onPressed: () {
                                      setState(() => _submitted = true);
                                      if (_formKey.currentState!.validate()) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          style: alertStyle,
                                          title: 'Warning',
                                          desc: "Mau simpan perubahan mom?",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                try {
                                                  await updateNotification(
                                                      name,
                                                      scheduledDateTime,
                                                      dropdownInitialValue
                                                          .value);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, true);
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
                                                                color: Colors
                                                                    .white,
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
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                      } else {
                                        return;
                                      }
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
                                ]),
                              ),
                              SizedBox(
                                height: Adaptive.h(2.5),
                              ),
                            ],
                          ),
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
                          title: const Text('Ubah Pengingat',
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
                              Expanded(
                                child: ConstrainedBox(
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
                                        onChanged: (value) {
                                          _controllerName.text = value;
                                        },
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
                                          hintText: 'Nama Pengingat',
                                          errorText: _submitted
                                              ? _errorTextNama
                                              : null,
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
                                          'Tanggal                                         ',
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
                                          initialPickerDateTime:
                                              scheduledDateTime,
                                          dateFormat:
                                              DateFormat('dd/MM/yyyy HH:mm'),
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
                                          mode: DateTimeFieldPickerMode
                                              .dateAndTime,
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
                                          'Frekuensi',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      DropDownTextField(
                                        controller: _cnt,
                                        dropDownList: _frekuensi,
                                        dropDownItemCount: 3,
                                        textStyle: TextStyle(
                                          fontFamily: 'DMSans',
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                        ),
                                        textFieldDecoration: InputDecoration(
                                          errorText:
                                              _submitted ? _errorTextJam : null,
                                          hintText: 'Frekuensi',
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
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isKeyboardVisible == false,
                                replacement: const SizedBox(),
                                child: Column(children: [
                                  EasyButton(
                                    type: EasyButtonType.elevated,
                                    onPressed: () {
                                      setState(() => _submitted = true);
                                      if (_formKey.currentState!.validate()) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          style: alertStyle,
                                          title: 'Warning',
                                          desc: "Mau hapus pengingat mom?",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                try {
                                                  await deleteNotification();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, true);
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
                                                                color: Colors
                                                                    .white,
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
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                      } else {
                                        return;
                                      }
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
                                    buttonColor: Colors.red.shade400,
                                    contentGap: 6.0,
                                    idleStateWidget: Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: 'DMSans',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Adaptive.h(1.5),
                                  ),
                                  EasyButton(
                                    type: EasyButtonType.elevated,
                                    onPressed: () {
                                      setState(() => _submitted = true);
                                      if (_formKey.currentState!.validate()) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          style: alertStyle,
                                          title: 'Warning',
                                          desc: "Mau simpan perubahan mom?",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                try {
                                                  await updateNotification(
                                                      name,
                                                      scheduledDateTime,
                                                      dropdownInitialValue
                                                          .value);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, true);
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
                                                                color: Colors
                                                                    .white,
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
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                      } else {
                                        return;
                                      }
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
                                ]),
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
}
