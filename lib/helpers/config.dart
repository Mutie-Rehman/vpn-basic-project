import 'dart:developer';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static final _config = FirebaseRemoteConfig.instance;

  // Correct the _defaultValues type to be a Map<String, dynamic> instead of a Set
  static const _defaultValues = {
    "show_ads": true,
    "native_ad": "ca-app-pub-3940256099942544/2247696110",
    "interstitial_ad": "ca-app-pub-3940256099942544/1033173712"
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 30),
    ));
    await _config.setDefaults(_defaultValues); // No need to cast here
    await _config.fetchAndActivate();
    log("Remote Config Data ${_config.getBool('show_ads')}");

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log("updated ${_config.getBool('show_ads')}");
    });
  }

  static bool get _showAdd => _config.getBool('show_ads');
  static String get interstitialAd => _config.getString('interstitial_ad');
  static String get nativeAd => _config.getString('native_ad');

  static bool get hideAds => !_showAdd;
}
