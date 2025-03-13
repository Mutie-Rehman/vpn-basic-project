import 'package:flutter/material.dart';
import 'package:vpn_basic_project/global/global_variables.dart';

class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final Widget icon;

  HomeCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SizedBox(
      width: mq.width * 0.45,
      child: Column(
        children: [
          icon,
          SizedBox(
            height: mq.height * 0.005,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: mq.height * 0.005,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
