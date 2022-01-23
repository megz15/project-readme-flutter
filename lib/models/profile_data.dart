class ProfileData {
  String UID;
  String uName;
  String pwd;
  String fName;
  String lName;
  String timestamp;
  String pfp;

  ProfileData(
      {required this.UID,
      required this.uName,
      required this.fName,
      required this.pwd,
      this.lName = '',
      required this.timestamp,
      required this.pfp,
      });

  factory ProfileData.fromJson(json) {
    return ProfileData(
      UID: json['UID'] ?? '',
      uName: json['uName'] ?? '',
      fName: json['fName'] ?? '',
      lName: json['lName'] ?? '',
      timestamp: json['timestamp'] ?? '',
      pfp: json['pfp'] ?? '',
      pwd: json['pwd'] ?? '',
    );
  }
}
