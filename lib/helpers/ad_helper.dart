import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';

class AdHelper {
  //Initialize Google Mobile Ads SDK
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  //interstitial ad
  static void showInterstitialAd({required VoidCallback onComplete}) {
    MyDialogs.showProgress();
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onComplete();
            },
          );
          Get.back();
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Get.back();
          print('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  // Load Native Ad
  static NativeAd loadNativeAd({required NativeAdController adController}) {
    return NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      factoryId: 'native', // Use the factoryId registered in MainActivity
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log("NativeAd loaded");
          adController.adLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          log("NativeAd failed to load: $error");
          adController.adLoaded.value = false;
          ad.dispose();
        },
      ),
      request: AdRequest(),
      nativeAdOptions: NativeAdOptions(),
    )..load();
  }
}
