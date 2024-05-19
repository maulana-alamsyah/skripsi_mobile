import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraTrimester1 extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String jenisYoga;
  const CameraTrimester1(
      {super.key, required this.cameras, required this.jenisYoga});

  @override
  State<CameraTrimester1> createState() => _CameraTrimester1State();
}

class _CameraTrimester1State extends State<CameraTrimester1> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
