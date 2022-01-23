class DownloadData {
  String get;
  String cloudflare;
  String ipfs;
  String infura;

  DownloadData({
    required this.get,
    required this.cloudflare,
    required this.ipfs,
    required this.infura,
  });

  factory DownloadData.fromJson(Map<String, dynamic> json){
    return DownloadData(
      get: json['GET'] ?? '',
      cloudflare: json['Cloudflare'] ?? '',
      ipfs: json['IPFS.io'] ?? '',
      infura: json['Infura'] ?? '',
    );
  }
}