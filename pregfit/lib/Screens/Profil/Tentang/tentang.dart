import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class Tentang extends StatefulWidget {
  const Tentang({super.key});

  @override
  State<Tentang> createState() => _TentangState();
}

class _TentangState extends State<Tentang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: Adaptive.h(8.7),
            title: const Text('Tentang',
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(right: 30, left: 30),
                childrenPadding: const EdgeInsets.only(right: 20, left: 20),
                backgroundColor: const Color.fromARGB(255, 232, 230, 230),
                title: RichText(
                    text: const TextSpan(children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.phone_in_talk,
                      color: Colors.black,
                      size: 23,
                    ),
                  ),
                  TextSpan(
                      text: '    Kontak Kami',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      )),
                ])),
                children: <Widget>[
                  const ListTile(
                      title: Text(
                          'Jika Anda mengalami kendala atau ada pertanyaan lainnya terkait penggunaan aplikasi Preg-Fit, Anda bisa mengirimkan ke :',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.black,
                              fontSize: 13.5))),
                  ListTile(
                      title: RichText(
                          text: TextSpan(children: [
                    const WidgetSpan(
                        child: Text('Whatsapp: ',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.black,
                              fontSize: 13.5,
                            ))),
                    TextSpan(
                        text: '+62 896-3609-2727\n',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(
                                Uri.parse(
                                    'https://api.whatsapp.com/send/?phone=%2B6289636092727&text&type=phone_number&app_absent=0'),
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        )),
                    const WidgetSpan(
                        child: Text('Email: ',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.black,
                              fontSize: 13.5,
                            ))),
                    TextSpan(
                        text: 'cs@preg-fit.id',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'mailto:destynurulanitsa24@gmail.com'));
                          },
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        )),
                  ]))),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(right: 30, left: 30),
                childrenPadding: const EdgeInsets.only(right: 20, left: 20),
                backgroundColor: const Color.fromARGB(255, 232, 230, 230),
                title: RichText(
                    text: const TextSpan(children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.perm_device_info,
                      color: Colors.black,
                      size: 23,
                    ),
                  ),
                  TextSpan(
                      text: '    Info Aplikasi',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      )),
                ])),
                children: const <Widget>[
                  ListTile(
                      title: Text(
                          '''Preg-Fit merupakan aplikasi yang dibuat untuk membantu para ibu hamil dalam melakukan senam yoga ibu hamil secara mandiri, kapan pun dan dimanapun. Preg-Fit dapat mendampingi bunda selayaknya instruktur senam yoga ibu hamil.
        
        Saat ini varsi aplikasi Preg-Fit yaitu 1.0''',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: Colors.black,
                            fontSize: 13.5,
                          )))
                ],
              ),
            ),
          ],
        ));
  }
}
