import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraTrimester2 extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String jenisYoga;
  const CameraTrimester2(
      {super.key, required this.cameras, required this.jenisYoga});

  @override
  State<CameraTrimester2> createState() => _CameraTrimester2State();
}

class _CameraTrimester2State extends State<CameraTrimester2> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
