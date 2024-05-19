import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pregfit/Config/config.dart';
import 'package:pregfit/Screens/OTP/otp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rflutter_alert/rflutter_alert.dart';

class ChatBot extends StatefulWidget {
  final String phoneNo;
  final String aksi;
  const ChatBot({
    super.key,
    required this.phoneNo,
    required this.aksi,
  });

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<types.Message> _messages = [];
  final _user = types.User(id: UniqueKey().toString());
  final _bot = types.User(
      id: UniqueKey().toString(), firstName: "Belly", lastName: "Bot");
  late int currentQ;
  late int roomChatStatus = 1;
  final List<types.User> _users = [];

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

  @override
  void initState() {
    super.initState();
    currentQ = 1;
    _handleBotMessage(const types.PartialText(
        text:
            'Hallo kenalin mom, aku belly bot. Selanjutnya belly akan minta mom untuk jawab pertanyaan dari belly secara jujur sesuai dg kondisi mom yaa. apakah mom sudah siap?'));
  }

  void _handleBotMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: UniqueKey().toString(),
      text: message.text,
    );

    _addMessage(textMessage);
    _users.add(_bot);
    var res = await chatbotPredict(message.text);
    String response = res['response'];
    currentQ++;
    _users.remove(_bot);
    _handleBotMessage(types.PartialText(text: response));
    print(res['value']);
    setState(() {
      roomChatStatus = res['value'];
    });
    if (res['value'] == 2) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OTP(
                      phoneNo: widget.phoneNo,
                      aksi: widget.aksi,
                      email: '',
                    )));
      });
    }
  }

  void _addMessage(types.Message message) {
    print("Adding message: $message");
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/chat/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  Future<dynamic> chatbotPredict(String message) async {
    try {
      final requestBodyBytes = utf8.encode(json.encode({'message': message}));
      final request =
          await client.postUrl(Uri.parse("${Config.baseURL}/api/chatbot"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.headers.set('Content-Length', requestBodyBytes.length.toString());
      request.write(json.encode({'message': message}));

      final response = await request.close();

      var responseBody =
          json.decode(await response.transform(utf8.decoder).join());

      print(responseBody);

      return responseBody;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: Adaptive.h(8.7),
          title: Container(
              padding: const EdgeInsets.only(left: 5),
              child:
                  Image.asset('assets/icons/logo.png', width: Adaptive.w(30))),
          titleSpacing: 5,
          elevation: 2,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
            size: Adaptive.h(4),
          )),
      body: Chat(
        customBottomWidget: roomChatStatus == 0
            ? Column(children: [
                Container(
                    width: double.infinity,
                    color: Colors.grey,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Adaptive.h(1.5)),
                        child: const Center(
                          child: Text(
                            'BellyBot mengakhiri obrolan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))),
                SizedBox(
                  height: Adaptive.h(1),
                )
              ])
            : roomChatStatus == 2
                ? Column(children: [
                    Container(
                        width: double.infinity,
                        color: Colors.grey,
                        child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: Adaptive.h(1.5)),
                            child: const Center(
                              child: Text(
                                'Mohon menunggu sebentar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))),
                    SizedBox(
                      height: Adaptive.h(1),
                    )
                  ])
                : null,
        l10n: const ChatL10nEn(inputPlaceholder: 'Ketik disini mom...'),
        typingIndicatorOptions: TypingIndicatorOptions(
            typingMode: TypingIndicatorMode.name, typingUsers: _users),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        inputOptions: const InputOptions(
            sendButtonVisibilityMode: SendButtonVisibilityMode.always),
        user: _user,
        theme: const DefaultChatTheme(
          inputBorderRadius: BorderRadius.all(Radius.circular(15)),
          inputMargin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          seenIcon: Text(
            'read',
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
