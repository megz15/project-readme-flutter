class BookData {
  String ID;
  String Author;
  String Title;
  String Publisher;
  String Year;
  String Pages;
  String Language;
  String Size;
  String Extension;
  String Mirror_1;
  String Mirror_2;
  String Mirror_3;
  String Mirror_4;
  String Mirror_5;
  String Edit;
  String img;

  BookData({
    this.ID = '',
    required this.Author,
    required this.Title,
    required this.Publisher,
    required this.Year,
    required this.Pages,
    required this.Language,
    required this.Size,
    required this.Extension,
    this.Mirror_1 = '',
    this.Mirror_2 = '',
    this.Mirror_3 = '',
    this.Mirror_4 = '',
    this.Mirror_5 = '',
    this.Edit = '',
    this.img = '',
  });

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      ID: json['ID'] ?? '',
      Author: json['Author'] ?? '',
      Title: json['Title'] ?? '',
      Publisher: json['Publisher'] ?? '',
      Year: json['Year'] ?? '',
      Pages: json['Pages'] ?? '',
      Language: json['Language'] ?? '',
      Size: json['Size'] ?? '',
      Extension: json['Extension'] ?? '',
      Mirror_1: json['Mirror_1'] ?? '',
      Mirror_2: json['Mirror_2'] ?? '',
      Mirror_3: json['Mirror_3'] ?? '',
      Mirror_4: json['Mirror_4'] ?? '',
      Mirror_5: json['Mirror_5'] ?? '',
      Edit: json['Edit'] ?? '',
      img: json['img'] ?? '',
    );
  }

  @override
  String toString() {
    return '{"ID":"$ID","Author":"$Author","Title":"$Title","Publisher":"$Publisher","Year":"$Year","Pages":"$Pages","Language":"$Language","Size":"$Size","Extension":"$Extension","Mirror_1":"$Mirror_1","Mirror_2":"$Mirror_2","Mirror_3":"$Mirror_3","Mirror_4":"$Mirror_4","Mirror_5":"$Mirror_5","Edit":"$Edit","img":"$img"}';
  }
}
