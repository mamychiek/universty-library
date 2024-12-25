import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBanner extends StatefulWidget {
  @override
  _AdMobBannerState createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-7803101616038858/5238677010', // Your banner ad unit ID
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (_, error) {
          print('BannerAd failed to load: $error');
        },
      ),
      size: AdSize.banner,
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: _bannerAd!),
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
          )
        : SizedBox(height: 50); // Placeholder height while loading
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
