import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../const/const.dart';
import '../const/style.dart';
import '../controllers/size.dart';

class BannerAdWidget extends StatefulWidget {
  final double sidePadding;

  const BannerAdWidget({
    super.key,
    this.sidePadding = 0
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final String adUnitId = UNIT_ID[Platform.isIOS ? 'ios' : 'android']!;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: AppColor.backgroundColor2,
          width: SizeController.to.screenWidth - (widget.sidePadding * 2),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else {
      return const SizedBox(width: 0, height: 50);
    }
  }
}