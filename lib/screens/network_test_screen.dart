import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    Apis.getIPDetails(ipData: ipData);
    return Scaffold(
      appBar: AppBar(
        title: Text("Network Test Screen"),
      ),
      body: Obx(
        () => ListView(
          physics: BouncingScrollPhysics(),
          children: [
            NetworkCard(
              data: NetworkData(
                title: "IP Address",
                subtitle: ipData.value.query,
                icon: Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.blue,
                ),
              ),
            ),
            NetworkCard(
              data: NetworkData(
                title: "Internet Provider",
                subtitle: ipData.value.isp,
                icon: Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
              ),
            ),
            NetworkCard(
              data: NetworkData(
                title: "Location",
                subtitle: ipData.value.country.isEmpty
                    ? "Fetching ..."
                    : "${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}",
                icon: Icon(
                  CupertinoIcons.location,
                  color: Colors.blue,
                ),
              ),
            ),
            NetworkCard(
              data: NetworkData(
                title: "Pin-Code ",
                subtitle: ipData.value.zip,
                icon: Icon(
                  CupertinoIcons.pin,
                  color: Colors.blue,
                ),
              ),
            ),
            NetworkCard(
              data: NetworkData(
                title: "Time Zone ",
                subtitle: ipData.value.timezone,
                icon: Icon(
                  CupertinoIcons.time,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          ipData.value = IPDetails.fromJson({});
          Apis.getIPDetails(ipData: ipData);
        },
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}
