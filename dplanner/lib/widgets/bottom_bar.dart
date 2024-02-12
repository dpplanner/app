import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          switch (index) {
            case 0:
              Get.offNamed('/tab1', arguments: 0);
              break;
            case 1:
              Get.offNamed('/tab2', arguments: 1);
              break;
            case 2:
              Get.offNamed('/tab3', arguments: 2);
              break;
            default:
              Get.offNamed('/tab2', arguments: 1);
              break;
          }
        });
      },
    );
  }
}
