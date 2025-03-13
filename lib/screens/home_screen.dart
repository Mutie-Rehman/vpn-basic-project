import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/global/global_variables.dart';
import 'package:vpn_basic_project/models/vpn_status.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text('Free Open VPN'),
        leading: Icon(CupertinoIcons.home),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.brightness_solid,
              color: Colors.black,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 10),
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
          ),
        ],
      ),

      //body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Obx(
          () => _vpnButton(),
        ),

//home cards
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Country Card
              HomeCard(
                title: _controller.vpn.value.CountryLong.isEmpty
                    ? "Country"
                    : _controller.vpn.value.CountryLong.toString(),
                subtitle: "Free",
                icon: _controller.vpn.value.CountryShort.isNotEmpty
                    ? CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 30,
                        child: FittedBox(
                          // ✅ Scale the flag within the circle
                          child: Text(
                            _getCountryFlag(_controller.vpn.value.CountryShort),
                            style: TextStyle(
                              fontSize:
                                  40, // ✅ Increase font size for better scaling
                            ),
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Icon(
                          Icons.vpn_lock_rounded,
                          color: Colors.white,
                        ),
                      ),
              ),

              // ✅ Ping Card
              HomeCard(
                title: _controller.vpn.value.CountryLong.isEmpty
                    ? "-- ms"
                    : "${_controller.ping.value} ms",
                subtitle: "PING",
                icon: CircleAvatar(
                  backgroundColor: Colors.orange.shade300,
                  radius: 30,
                  child: Icon(
                    Icons.equalizer_rounded,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),

        //Stream Builder

        //Stream Builder Code
        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                  title: "${snapshot.data?.byteIn ?? "0 kbps"}",
                  subtitle: "Download",
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.shade300,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                  )),
              HomeCard(
                title: "${snapshot.data?.byteOut ?? "0 kbps"}",
                subtitle: "Upload",
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: _changeLocation(),
    );
  }

//VPN BUTTON
  Widget _vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(80),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    width: mq.height * .16,
                    height: mq.height * .16,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? "Not Connected"
                  : _controller.vpnState.replaceAll('_', '').toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          //count down timer
          Obx(() => CountDownTimer(startTimer: _controller.startTimer.value)),
        ],
      );
}

//Change Location Widget
Widget _changeLocation() => SafeArea(
      child: InkWell(
        onTap: () {
          Get.to(() => LocationScreen());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
          color: Colors.blue,
          height: mq.height * 0.075,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.globe,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Change Location",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              Spacer(),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.blue,
                  size: 26,
                ),
              )
            ],
          ),
        ),
      ),
    );

// Get country flag emoji using country code
String _getCountryFlag(String countryCode) {
  if (countryCode.length != 2) return '';

  // Convert country code to emoji
  String flag = countryCode.toUpperCase().replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
      );

  return flag;
}
