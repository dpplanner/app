import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../const/style.dart';

class SimpleInfoPage extends StatefulWidget {
  final String title;
  final String filePath;

  const SimpleInfoPage({Key? key, required this.title, required this.filePath}) : super(key: key);

  @override
  State<SimpleInfoPage> createState() => _SimpleInfoPageState();
}

class _SimpleInfoPageState extends State<SimpleInfoPage> {
  String info = "";

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    String privacyText = await rootBundle.loadString(widget.filePath);
    setState(() {
      info = privacyText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: SingleChildScrollView(
              child: Text(
                info,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColor.textColor
                ),
              ),
            ),
          )
      ),
    );
  }

}