import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  const VpnCard({super.key, required this.vpn});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final locationController = Get.find<LocationController>();
    return InkWell(
      onTap: () async {
        // ✅ Save VPN to local storage when tapped
        await locationController.saveSelectedVpn(vpn);
        // ✅ Set VPN details and ping when a VPN is selected
        controller.vpn.value = vpn;
        controller.ping.value = vpn.Speed ~/ 1024; // ✅ Convert to ms
        Get.back();
        if (controller.vpnState.value == VpnEngine.vpnConnected) {
          VpnEngine.stopVpn();
          Future.delayed(Duration(seconds: 2), () {
            controller.connectToVpn();
          });
        } else {
          controller.connectToVpn();
        }
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Country Flag
              _getCountryFlag(vpn.CountryShort),

              const SizedBox(width: 12),

              // ✅ VPN Details (Country + Speed)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Show Country Name
                    Text(
                      vpn.CountryLong,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // ✅ Speed
                    Row(
                      children: [
                        const Icon(
                          Icons.cloud_download_outlined,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatSpeed(vpn.Speed),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).lightText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ✅ Active Sessions and Arrow Icon
              Column(
                children: [
                  Text(
                    '${vpn.NumVpnSessions}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).lightText,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get country flag emoji using country code
  Widget _getCountryFlag(String countryCode) {
    if (countryCode.length != 2) return const SizedBox();

    // Convert country code to emoji
    String flag = countryCode.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );

    return Text(
      flag,
      style: const TextStyle(fontSize: 32),
    );
  }

  /// Format download speed to readable format
  String _formatSpeed(int speed) {
    if (speed < 1024) {
      return '$speed Kbps';
    } else if (speed < 1024 * 1024) {
      return '${(speed / 1024).toStringAsFixed(2)} Mbps';
    } else {
      return '${(speed / (1024 * 1024)).toStringAsFixed(2)} Gbps';
    }
  }
}
