import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../config/constants/ad_unit_id.dart';
import '../../../../config/constants/app_colors.dart';

class AdBanner extends StatefulWidget {
  final double sidePadding;

  const AdBanner({
    super.key,
    this.sidePadding = 0
  });

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
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
          color: AppColors.bgWhite,
          width: MediaQuery.of(context).size.width - (widget.sidePadding * 2),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else {
      return const SizedBox(width: 0, height: 50);
    }
  }
}