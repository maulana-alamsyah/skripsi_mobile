import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Controller/api_controller.dart';

import 'package:pregfit/Screens/Menu/menu.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'package:pregfit/Screens/Camera/preview_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CameraTrimester1 extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String jenisYoga;
  const CameraTrimester1(
      {super.key, required this.cameras, required this.jenisYoga});
  @override
  State<CameraTrimester1> createState() => _CameraTrimester1State();
}

class _CameraTrimester1State extends State<CameraTrimester1> {
  late CameraController _cameraController;
  final TextEditingController _controllerFeedback = TextEditingController();
  int _remainingTime = 60;
  int _timerCount = 2;
  Timer? _timer;
  bool _showDialog = true;
  String urlGif = '';
  late String currentYoga;
  late IO.Socket socket;
  late Timer _captureTimer;
  Uint8List? imageData;
  String? poseClass;
  String? prob;
  bool showImage = false;
  AudioPlayer audioPlayerMain = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlayingAudio = false;
  StreamSubscription? audioCompleteSubscription;
  APIController apiController = APIController();

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![1]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    setState(() {
      currentYoga = 'Side Bend Pose';
      urlGif = 'assets/images/sb.gif';
    });

    startAudioCompleteSubscription();

    socket = IO.io(Config.baseURL, <String, dynamic>{
      'transports': ['websocket'],
    });

    // Handle the connection event
    socket.onConnect((_) {
      debugPrint('Connected');
    });

    socket.on('imageResponse', (data) {
      // Handle the image response received from the server
      setState(() {
        List<int> imageData =
            base64Decode(data['imageData']).cast<int>().toList();
        imageData = Uint8List.fromList(imageData);
        poseClass = data['pose_class'];
        prob = data['prob'];
        showImage = true;
      });
      if (showImage && poseClass != currentYoga) {
        playAudio('audio/false.mp3');
      }
      Timer(const Duration(seconds: 1), () {
        setState(() {
          showImage = false;
        });
      });
    });

    // Handle the disconnection event
    socket.onDisconnect((_) {
      debugPrint('Disconnected');
    });
    startTimer();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.restoreSystemUIOverlays();
    audioPlayer.dispose();
    audioPlayerMain.dispose();
    _captureTimer.cancel();
    cancelAudioCompleteSubscription();
    _cameraController.stopImageStream();
    _cameraController.dispose();
    socket.disconnect();
    _timer?.cancel();
    stopMainAudio();
    super.dispose();
  }

  void startAudioCompleteSubscription() {
    audioCompleteSubscription ??= audioPlayer.onPlayerComplete.listen((event) {
      isPlayingAudio = false;
      playMainAudio('audio/sounds.mp3');
    });
  }

  void cancelAudioCompleteSubscription() {
    audioCompleteSubscription?.cancel();
    audioCompleteSubscription = null;
  }

  void playAudio(String audioPath) async {
    if (isPlayingAudio) {
      return;
    }
    pauseMainAudio();

    await audioPlayer.play(AssetSource(audioPath));
    // success
    // print('Audio playback started');
    isPlayingAudio = true;

    // // Listen for audio completion
    // audioPlayer.onPlayerComplete.listen((event) {
    //   // print('Audio playback completed');
    //   isPlayingAudio = false;
    //   // // Call a function to play the next audio here
    //   playMainAudio('audio/sounds.mp3');
    // });
  }

  void onComplete() {
    // Perform actions after audio playback completes
    // For example, you can stop the playback or reset the audio player
    audioPlayerMain.stop();
    audioPlayerMain
        .seek(Duration.zero); // Reset playback position to the beginning
  }

  void playMainAudio(String path) async {
    await audioPlayerMain.play(AssetSource(path));
    debugPrint('Audio playback started');
  }

  void pauseMainAudio() async {
    await audioPlayerMain.pause();
    debugPrint('Audio playback paused');
  }

  void stopMainAudio() async {
    await audioPlayerMain.stop();
    debugPrint('Audio playback stopped');
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    playMainAudio('audio/sounds.mp3');
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_timerCount == 2) {
        setState(() {
          currentYoga = 'Side Bend Pose';
          urlGif = 'assets/images/sb.gif';
        });
      } else if (_timerCount == 1) {
        setState(() {
          currentYoga = 'Child Pose';
          urlGif = 'assets/images/cp.gif';
        });
      }

      if (_remainingTime == 0) {
        if (_timerCount == 1) {
          _captureTimer.cancel();
          stopMainAudio();
          cancelAudioCompleteSubscription();
          timer.cancel();
          if (_showDialog) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: const Center(child: Text('Selamat!')),
                  content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const Text(
                        '''Mom telah menyelesaikan \nsenam yoga ibu hamil''',
                        style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    FractionallySizedBox(
                        widthFactor: 0.4,
                        child: ElevatedButton(
                                                  onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                                  child: AlertDialog(
                                      title:
                                          const Center(child: Text('Feedback')),
                                      content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                            children: [
                                              const Text(
                                                '''Gimana pengalaman senam mom tadi ?. \nbisa diceritain ke Preg-Fit yaaa''',
                                                style: TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign:
                                                    TextAlign.center,
                                              ),
                                              SizedBox(
                                                  height: Adaptive.h(3)),
                                              TextFormField(
                                                controller:
                                                    _controllerFeedback,
                                                decoration:
                                                    InputDecoration(
                                                  border:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                  ),
                                                  hintText: '',
                                                ),
                                              ),
                                            ],
                                          )),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        FractionallySizedBox(
                                          widthFactor: 0.4,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              isPlayingAudio = true;
                                              stopMainAudio();
                                              cancelAudioCompleteSubscription();
                                              _captureTimer.cancel();
                                              // socket.disconnect();
                                              _showDialog = false;
                                              SystemChrome
                                                  .setPreferredOrientations([
                                                DeviceOrientation
                                                    .portraitUp,
                                                DeviceOrientation
                                                    .portraitDown,
                                              ]);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              const Menu(
                                                                index: 0,
                                                              )));
                                            },
                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              child: Center(
                                                child: Text(
                                                  'Lain Kali',
                                                  style: TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign:
                                                      TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.4,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await apiController.addFeedback(
                                                    _controllerFeedback
                                                        .text);
                                                isPlayingAudio = true;
                                                stopMainAudio();
                                                cancelAudioCompleteSubscription();
                                                _captureTimer.cancel();
                                                // socket.disconnect();
                                                _showDialog = false;
                                                SystemChrome
                                                    .setPreferredOrientations([
                                                  DeviceOrientation
                                                      .portraitUp,
                                                  DeviceOrientation
                                                      .portraitDown,
                                                ]);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                const Menu(
                                                                  index:
                                                                      0,
                                                                )));
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                            },
                                            style:
                                                ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0, bottom: 0),
                                              child: Center(
                                                child: Text(
                                                  'Kirim',
                                                  style: TextStyle(
                                                    fontFamily: 'DMSans',
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign:
                                                      TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)))),
                                ));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                                                  child: const Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Center(
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                                                  ),
                                                )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            );
          }
        } else {
          _timerCount--;
          _remainingTime = 60;
        }
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    picture: picture,
                  )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {});

      _captureTimer = Timer.periodic(const Duration(seconds: 7), (_) {
        captureAndProcessFrame();
      });
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  void captureAndProcessFrame() async {
    try {
      final image = await _cameraController.takePicture();
      // // Read the image file and decode it
      final imageBytes = await image.readAsBytes();
      // final originalImage = img.decodeImage(imageBytes);
      // final flippedImage = img.flipHorizontal(originalImage!);
      // final flippedBytes = img.encodeJpg(flippedImage);

      // final Directory tempDir = await getTemporaryDirectory();
      // final String tempPath = tempDir.path;
      // final String flippedImagePath = '$tempPath/flipped_image.jpg';

      // final File flippedFile = File(flippedImagePath);
      // await flippedFile.writeAsBytes(flippedBytes);

      // final XFile image_a = XFile(flippedFile.path);

      final ui.Image capturedImage = await decodeImageFromList(imageBytes);

      // Get the height and width of the captured image
      final int imageHeight = capturedImage.height;
      final int imageWidth = capturedImage.width;
      await processFrame(image, imageHeight, imageWidth);
    } catch (e) {
      debugPrint("Error occurred during image capture or processing: $e");
    }
  }

  Future<void> processFrame(XFile image, int height, int width) async {
    try {
      final bytes = await image.readAsBytes();
      final imageData = Uint8List.fromList(bytes);

      // Encode the image data as base64
      final encodedImage = base64Encode(imageData);

      // Decode the image to get its dimensions
      final ui.Image decodedImage = await decodeImageFromList(imageData);
      final actualHeight = decodedImage.height;
      final actualWidth = decodedImage.width;

      // Check if the provided height and width match the actual dimensions
      if (height != actualHeight || width != actualWidth) {
        debugPrint('Error: Invalid image dimensions provided');
        return;
      }
      socket.emit('image',
          {"imageData": encodedImage, "height": height, "width": width});
    } catch (e) {
      debugPrint("Error occurred during image processing: $e");
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Center(child: Text('Selamat!')),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Text(
                '''Mom telah menyelesaikan \nsenam yoga ibu hamil''',
                style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FractionallySizedBox(
                widthFactor: 0.4,
                child: ElevatedButton(
                                  onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                          child: AlertDialog(
                              title: const Center(child: Text('Feedback')),
                              content: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        '''Gimana pengalaman senam mom tadi ?. \nbisa diceritain ke Preg-Fit yaaa''',
                                        style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: Adaptive.h(3)),
                                      TextFormField(
                                        controller: _controllerFeedback,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          hintText: '',
                                        ),
                                      ),
                                    ],
                                  )),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                FractionallySizedBox(
                                  widthFactor: 0.4,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      isPlayingAudio = true;
                                      stopMainAudio();
                                      cancelAudioCompleteSubscription();
                                      _captureTimer.cancel();
                                      // socket.disconnect();
                                      _showDialog = false;
                                      SystemChrome
                                          .setPreferredOrientations([
                                        DeviceOrientation.portraitUp,
                                        DeviceOrientation.portraitDown,
                                      ]);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Menu(
                                                    index: 0,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: Center(
                                        child: Text(
                                          'Lain Kali',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.4,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await apiController.addFeedback(
                                            _controllerFeedback.text);
                                        isPlayingAudio = true;
                                        stopMainAudio();
                                        cancelAudioCompleteSubscription();
                                        _captureTimer.cancel();
                                        // socket.disconnect();
                                        _showDialog = false;
                                        SystemChrome
                                            .setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                          DeviceOrientation.portraitDown,
                                        ]);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Menu(
                                                      index: 0,
                                                    )));
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 0, bottom: 0),
                                      child: Center(
                                        child: Text(
                                          'Kirim',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)))),
                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                                  child: const Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                                  ),
                                )),
            const SizedBox(
              width: 10,
            ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // channel.sink.add('a');
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromRGBO(130, 165, 255, 1), // Set your desired color here
    ));
    if (!_cameraController.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final cameraAspectRatio = _cameraController.value.aspectRatio;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
            top: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: cameraAspectRatio,
                    child: imageData != null &&
                            imageData!.isNotEmpty &&
                            showImage
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                                3.14159), // Apply vertical flip transformation
                            child: Image.memory(
                              imageData!,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ))
                        : CameraPreview(_cameraController),
                  ),
                ),
                OrientationBuilder(
                  builder: (context, orientation) {
                    return RotatedBox(
                        quarterTurns: orientation == Orientation.landscape
                            ? 0
                            : 3, // Rotate the text 90 degrees counter-clockwise in portrait mode
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //       height: screenHeight * 0.3,
                            //       width: screenHeight * 0.4,
                            //       child: imageData != null && imageData!.isNotEmpty
                            //             ? Image.memory(imageData!)
                            //             : Container(),
                            //     ),
                            SizedBox(
                              height: screenHeight * 0.36,
                              width: screenWidth * 0.45,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GifView.asset(
                                    urlGif,
                                    height: constraints.maxHeight,
                                    width: constraints.maxWidth,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.15,
                              width: screenHeight * 0.15,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(217, 217, 217, 217),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                  child: Text(
                                '$_remainingTime',
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              )),
                            ),
                            poseClass != null && poseClass!.isNotEmpty
                                ? Container(
                                    color: Colors.black,
                                    height: screenHeight * 0.12,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Class: ${poseClass!}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          'Prob: ${prob!}',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.none),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ));
                  },
                ),
              ],
            )));
  }
}
