import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _locationController = Get.put(LocationController());
    _locationController.getVpnData();
    return GetBuilder<LocationController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "VPN LOCATIONS (${controller.vpnList.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 4,
          ),
          body: controller.isLoading.value
              ? _loadingWidget()
              : controller.vpnList.isEmpty
                  ? _noVpnFound()
                  : _vpnData(controller),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              controller.vpnList.clear(); // ✅ Clear previous data
              controller.isLoading.value = true;
              controller.update();
              await controller.getVpnData(); // ✅ Fetch new data
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _loadingWidget() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
              "Refreshing VPN data...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );

  Widget _noVpnFound() => const Center(
        child: Text(
          "No VPNs Found, Please Refresh",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      );

  Widget _vpnData(LocationController controller) => ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.vpnList.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final vpn = controller.vpnList[index];

          // ✅ Use the VpnCard widget here
          return VpnCard(vpn: vpn);
        },
      );
}
