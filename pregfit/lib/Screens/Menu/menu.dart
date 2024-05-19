import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pregfit/Screens/CustomIcons/custom_icons_icons.dart';
import 'package:pregfit/Screens/History/history.dart';
import 'package:pregfit/Screens/Home/home.dart';
import 'package:pregfit/Screens/Profil/profil.dart';
import 'package:pregfit/Screens/Yoga/yoga.dart';

class Menu extends StatefulWidget {
  final int index;
  const Menu({super.key, required this.index});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int _currentIndex = widget.index;
  final List<Widget> _children = [
    const Home(),
    const Yoga(),
    const History(),
    const Profil()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.07;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(130, 165, 255, 1),
    ));
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
            child: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.home),
                  label: 'Home',
                  backgroundColor: Color.fromARGB(255, 211, 225, 248),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.yoga),
                  label: 'Yoga',
                  backgroundColor: Color.fromARGB(255, 211, 225, 248),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.history),
                  label: 'History',
                  backgroundColor: Color.fromARGB(255, 211, 225, 248),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CustomIcons.profile),
                  label: 'Profil',
                  backgroundColor: Color.fromARGB(255, 211, 225, 248),
                )
              ],
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.blue,
            ),
          )),
    );
  }
}
