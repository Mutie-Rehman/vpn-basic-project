import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationController extends GetxController {
  List<Vpn> vpnList = [];
  final RxBool isLoading = false.obs;

  Vpn? selectedVpn;

  @override
  void onInit() {
    super.onInit();
    loadVpnList(); // ✅ Load VPN list from cache on startup
    loadSelectedVpn(); // ✅ Load selected VPN
  }

  // ✅ Get VPN data from API or cache
  Future<void> getVpnData() async {
    // ✅ If list is already available from cache, don't fetch from API
    if (vpnList.isNotEmpty) return;

    isLoading.value = true;
    vpnList.clear();

    // ✅ Try to load from cache first
    await loadVpnList();

    // ✅ If cache is empty, call API
    if (vpnList.isEmpty) {
      vpnList = await Apis.getVPNServers();
      await saveVpnList(vpnList);
    }

    isLoading.value = false;
    update(); // Refresh UI
  }

  // ✅ Save VPN list to SharedPreferences
  Future<void> saveVpnList(List<Vpn> list) async {
    final prefs = await SharedPreferences.getInstance();
    final vpnJson = jsonEncode(list.map((vpn) => vpn.toJson()).toList());
    await prefs.setString('vpn_list', vpnJson);
  }

  // ✅ Load VPN list from SharedPreferences
  Future<void> loadVpnList() async {
    final prefs = await SharedPreferences.getInstance();
    final vpnJson = prefs.getString('vpn_list');

    if (vpnJson != null) {
      List<dynamic> decodedList = jsonDecode(vpnJson);
      vpnList = decodedList.map((item) => Vpn.fromJson(item)).toList();
      update(); // ✅ Refresh UI when data is loaded
    }
  }

  // ✅ Save selected VPN to SharedPreferences
  Future<void> saveSelectedVpn(Vpn vpn) async {
    final prefs = await SharedPreferences.getInstance();
    final vpnJson = jsonEncode(vpn.toJson());
    await prefs.setString('selected_vpn', vpnJson);
    selectedVpn = vpn;
    update();
  }

  // ✅ Load selected VPN from SharedPreferences
  Future<void> loadSelectedVpn() async {
    final prefs = await SharedPreferences.getInstance();
    final vpnJson = prefs.getString('selected_vpn');

    if (vpnJson != null) {
      selectedVpn = Vpn.fromJson(jsonDecode(vpnJson));
      update();
    }
  }

  // ✅ Force Refresh (Clear Cache + Call API)
  Future<void> refreshVpnData() async {
    isLoading.value = true;
    vpnList.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('vpn_list'); // ✅ Clear cached data

    vpnList = await Apis.getVPNServers();
    await saveVpnList(vpnList);

    isLoading.value = false;
    update();
  }
}
