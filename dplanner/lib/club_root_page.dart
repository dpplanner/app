import 'package:dplanner/pages/club_home_page.dart';
import 'package:dplanner/pages/club_my_page.dart';
import 'package:dplanner/pages/club_timetable_page.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'controllers/size.dart';

class ClubRootPage extends StatefulWidget {
  const ClubRootPage({super.key});

  @override
  State<ClubRootPage> createState() => _ClubRootPageState();
}

class _ClubRootPageState extends State<ClubRootPage> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    const ClubTimetablePage(),
    const ClubHomePage(),
    const ClubMyPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 25,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        unselectedFontSize: 10,
        selectedItemColor: Colors.black,
        selectedFontSize: 10,

        ///TODO: 아이콘 & 높이 및 크기 변경
        items: const [
          BottomNavigationBarItem(icon: Icon(SFSymbols.calendar), label: '예약'),
          BottomNavigationBarItem(icon: Icon(SFSymbols.house), label: '클럽 소식'),
          BottomNavigationBarItem(icon: Icon(SFSymbols.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
