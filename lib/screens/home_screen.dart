import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:vpn_basic_project/global/global_variables.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';

import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _vpnState = VpnEngine.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

  final RxBool _startTimer = false.obs;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      setState(() => _vpnState = event);
    });

    initVpn();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
        country: 'Thailand',
        username: 'vpn',
        password: 'vpn'));

    SchedulerBinding.instance.addPostFrameCallback(
        (t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
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
        _vpnButton(),

        //home cards
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeCard(
              title: "Countary",
              subtitle: "Free",
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: Icon(
                  Icons.vpn_lock_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            HomeCard(
                title: "100ms",
                subtitle: "PING",
                icon: CircleAvatar(
                  backgroundColor: Colors.orange.shade300,
                  radius: 30,
                  child: Icon(
                    Icons.equalizer_rounded,
                    color: Colors.blue,
                  ),
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeCard(
                title: "0 kbps",
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
              title: "0 kpbs",
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
      ]),
      bottomNavigationBar: _changeLocation(),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_vpnState == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

//VPN BUTTON
  Widget _vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _startTimer.value = !_startTimer.value;
              },
              borderRadius: BorderRadius.circular(80),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 201, 231, 255)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 165, 214, 255)),
                  child: Container(
                    width: mq.height * .16,
                    height: mq.height * .16,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
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
                          "Tap to Connect",
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
              "Not Connected",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          //count down timer
          Obx(() => CountDownTimer(startTimer: _startTimer.value)),
        ],
      );
}

//Change Location Widget
Widget _changeLocation() => SafeArea(
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
    );

/*
 Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      _vpnState == VpnEngine.vpnDisconnected
                          ? 'Connect VPN'
                          : _vpnState.replaceAll("_", " ").toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _connectClick,
                  ),
                ),
                StreamBuilder<VpnStatus?>(
                  initialData: VpnStatus(),
                  stream: VpnEngine.vpnStatusSnapshot(),
                  builder: (context, snapshot) => Text(
                      "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
                      textAlign: TextAlign.center),
                ),

                //sample vpn list
                Column(
                    children: _listVpn
                        .map(
                          (e) => ListTile(
                            title: Text(e.country),
                            leading: SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                  child: _selectedVpn == e
                                      ? CircleAvatar(
                                          backgroundColor: Colors.green)
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey)),
                            ),
                            onTap: () {
                              log("${e.country} is selected");
                              setState(() => _selectedVpn = e);
                            },
                          ),
                        )
                        .toList()),
*/
