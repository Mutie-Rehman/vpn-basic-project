import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_basic_project/models/vpn.dart';

class Apis {
  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await http
          .get(
            Uri.parse('http://www.vpngate.net/api/iphone/'),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        if (res.body.isEmpty) {
          log('Response is empty');
          return [];
        }

        // Split response and validate structure
        final splitData = res.body.split("#");
        if (splitData.length < 2 || splitData[1].isEmpty) {
          log('Invalid CSV format');
          return [];
        }

        final csvString = splitData[1].replaceAll('*', '');

        // Use Stream to handle large data chunks
        final stream = Stream.fromIterable(
          const LineSplitter().convert(csvString),
        );

        bool isHeader = true;
        List<String> headers = [];

        await for (final line in stream) {
          if (line.trim().isEmpty) continue; // ✅ Skip empty lines

          if (isHeader) {
            try {
              headers = const CsvToListConverter()
                  .convert(line)[0]
                  .map((e) => e.toString())
                  .toList();

              if (headers.isEmpty) {
                log('Invalid headers: $headers');
                return [];
              }

              log('Headers extracted: $headers');
              isHeader = false;
            } catch (e) {
              log('Error parsing headers: $e');
              return [];
            }
          } else {
            try {
              List<dynamic> row = const CsvToListConverter().convert(line)[0];

              // ✅ Ensure row length matches headers length
              if (row.length == headers.length) {
                Map<String, dynamic> tempJson = {};
                for (int i = 0; i < headers.length; i++) {
                  tempJson[headers[i]] = row[i];
                }
                vpnList.add(Vpn.fromJson(tempJson));
              } else {
                log('Skipping row due to length mismatch: $row');
              }
            } catch (e) {
              log('Error parsing row: $e');
            }
          }
        }

        log("Total VPNs fetched: ${vpnList.length}");
      } else {
        log('Failed to fetch VPN servers. Status code: ${res.statusCode}');
      }
    } catch (e) {
      log('Error fetching VPN servers: $e');
    }
    vpnList.shuffle();
    return vpnList;
  }
}
