import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraTrimester3 extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String jenisYoga;
  const CameraTrimester3(
      {super.key, required this.cameras, required this.jenisYoga});

  @override
  State<CameraTrimester3> createState() => _CameraTrimester3State();
}

class _CameraTrimester3State extends State<CameraTrimester3> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
