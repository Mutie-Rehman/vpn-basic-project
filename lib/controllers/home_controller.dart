import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/models/vpn_config.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Vpn.fromJson({}).obs;
  final RxInt ping = 0.obs;
  final RxBool startTimer = false.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSelectedVpn(); // ✅ Load last VPN on start
  }

  // ✅ Load last selected VPN
  Future<void> _loadSelectedVpn() async {
    final prefs = await SharedPreferences.getInstance();
    final vpnJson = prefs.getString('selected_vpn');
    if (vpnJson != null) {
      vpn.value = Vpn.fromJson(jsonDecode(vpnJson));
      ping.value = vpn.value.Speed ~/ 1024;

      // ✅ Restore VPN state and auto-connect
      final wasConnected = prefs.getBool('vpn_connected') ?? false;
      if (wasConnected) {
        _connectToVpn(shouldReconnect: true);
      }
    }
  }

  // ✅ Save VPN state when connecting
  Future<void> _saveVpnState(bool isConnected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vpn_connected', isConnected);
  }

  // ✅ Connect to VPN
  void connectToVpn() {
    _connectToVpn(shouldReconnect: false);
  }

  void _connectToVpn({bool shouldReconnect = false}) {
    if (vpn.value.OpenVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(msg: "Select a location by clicking \'Change Location\'");
      return;
    }
    ;

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = Base64Decoder().convert(vpn.value.OpenVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
          country: vpn.value.CountryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);

      /// Start if stage is disconnected
      startTimer.value = true;
      //showing interstitial Ad
      AdHelper.showInterstitialAd(onComplete: () {
        VpnEngine.startVpn(vpnConfig);
      });

      _saveVpnState(true); // ✅ Save state when connected
    } else {
      /// Stop if connected
      startTimer.value = false;
      VpnEngine.stopVpn();
      _saveVpnState(false); // ✅ Save state when disconnected

      // ✅ Reconnect if needed
      if (shouldReconnect) {
        Future.delayed(Duration(seconds: 2), () {
          _connectToVpn();
        });
      }
    }
  }

  // ✅ Clear last VPN state and data
  Future<void> clearVpnState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_vpn'); // Remove VPN info
    await prefs.remove('vpn_connected'); // Remove VPN state
    vpn.value = Vpn.fromJson({}); // Clear the VPN object
    ping.value = 0; // Reset ping value
    update(); // Refresh UI
  }

  //getter for vpn button color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  //getter for vpn button text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return "Tap to Connect";
      case VpnEngine.vpnConnected:
        return "Disconnect";
      default:
        return "Connecting";
    }
  }
}
