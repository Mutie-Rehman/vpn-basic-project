class Vpn {
  Vpn({
    required this.HostName,
    required this.IP,
    required this.Ping,
    required this.Speed,
    required this.CountryLong,
    required this.CountryShort,
    required this.NumVpnSessions,
    required this.OpenVPNConfigDataBase64,
  });
  late final String HostName;
  late final String IP;
  late final String Ping;
  late final int Speed;
  late final String CountryLong;
  late final String CountryShort;
  late final int NumVpnSessions;
  late final String OpenVPNConfigDataBase64;

  Vpn.fromJson(Map<String, dynamic> json) {
    HostName = json['HostName'] ?? '';
    IP = json['IP'] ?? '';
    Ping = json['Ping'].toString();
    Speed = json['Speed'] ?? 0;
    CountryLong = json['CountryLong'] ?? '';
    CountryShort = json['CountryShort'] ?? '';
    NumVpnSessions = json['NumVpnSessions'] ?? 0;
    OpenVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['HostName'] = HostName;
    _data['IP'] = IP;
    _data['Ping'] = Ping;
    _data['Speed'] = Speed;
    _data['CountryLong'] = CountryLong;
    _data['CountryShort'] = CountryShort;
    _data['NumVpnSessions'] = NumVpnSessions;
    _data['OpenVPN_ConfigData_Base64'] = OpenVPNConfigDataBase64;
    return _data;
  }
}
