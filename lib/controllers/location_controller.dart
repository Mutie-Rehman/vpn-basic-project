import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/vpn.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = [];

  final RxBool isLoading = true.obs;

  Future<void> getVpnData() async {
    isLoading.value = true;

    vpnList = await Apis.getVPNServers();

    isLoading.value = false;
    update(); // Refresh UI when data is loaded
  }
}
