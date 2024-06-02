// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
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

class TambahPengingat extends StatefulWidget {
  const TambahPengingat({super.key});

  @override
  State<TambahPengingat> createState() => _TambahPengingatState();
}

class _TambahPengingatState extends State<TambahPengingat> {
  final TextEditingController _controllerName = TextEditingController();
  bool _submitted = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool isKeyboardVisible = false;
  late SingleValueDropDownController _cnt;

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
    _keyboardVisibilitySubscription?.cancel();
    super.dispose();
  }

  Future<dynamic> tambahPengingat(
      String nama, DateTime tanggal, String frekuensi) async {
    // var token = box.read('token');
    // var token = "test";
    var id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    var weekday = tanggal.weekday;
    var hour = tanggal.hour;
    var minute = tanggal.minute;

    try {
      if (frekuensi == 'Harian') {
        await NotificationController.createNewDailyReminder(
            id: id, summary: nama, hour: hour, minute: minute);
      } else if (frekuensi == 'Mingguan') {
        await NotificationController.createNewWeeklyReminder(
            id: id,
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

  Future<bool> _onWillPop() async {
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
                      _errorTextJam == null &&
                      _controllerName.value.text.isNotEmpty &&
                      _cnt.dropDownValue?.value.isNotEmpty) {
                    await tambahPengingat(
                        _controllerName.text,
                        selectedDate != null ? selectedDate! : DateTime.now(),
                        _cnt.dropDownValue?.value);
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
                Navigator.pop(context, true);
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
    return keyboard.KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool isKeyboardVisible) {
      return WillPopScope(
          onWillPop: () => _onWillPop(),
          child: Scaffold(
              appBar: AppBar(
                  toolbarHeight: Adaptive.h(8.7),
                  title: const Text('Tambah Pengingat',
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
                                hintText: 'Nama Pengingat',
                                errorText: _submitted ? _errorTextNama : null,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: Adaptive.h(2)),
                                prefix: Padding(
                                    padding:
                                        EdgeInsets.only(left: Adaptive.h(2))),
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
                                    selectedDate ?? DateTime.now(),
                                dateFormat: DateFormat('dd/MM/yyyy HH:mm'),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Tanggal',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(Adaptive.h(2)),
                                ),
                                value: selectedDate ?? DateTime.now(),
                                mode: DateTimeFieldPickerMode.dateAndTime,
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
                                errorText: _submitted ? _errorTextJam : null,
                                hintText: 'Frekuensi',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: Adaptive.h(2)),
                                prefix: Padding(
                                    padding:
                                        EdgeInsets.only(left: Adaptive.h(2))),
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
                                if (_errorTextNama == null &&
                                    _errorTextJam == null &&
                                    _controllerName.value.text.isNotEmpty &&
                                    _cnt.dropDownValue?.value.isNotEmpty) {
                                  selectedDate ??= DateTime.now();
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
                                            await tambahPengingat(
                                                _controllerName.text,
                                                selectedDate!,
                                                _cnt.dropDownValue?.value);
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
                              height: MediaQuery.of(context).size.height * 0.05,
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
    });
  }
}
