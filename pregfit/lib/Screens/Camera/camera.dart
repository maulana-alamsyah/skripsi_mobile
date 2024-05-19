import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String jenisYoga;
  const Camera({super.key, required this.cameras, required this.jenisYoga});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
