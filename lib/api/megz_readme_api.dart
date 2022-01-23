import 'dart:convert';
import 'package:readme/models/models.dart';
import 'package:http/http.dart' as http;

class MegzReadmeApi {
  Future<String> getapiPath() async{
    final dataString = await http.get(Uri.parse('https://raw.githubusercontent.com/megz15/project-readme-website/main/apiPath'));
    return dataString.body;
  }

  Future<List<BookData>> getBookData(String book) async {
    final apiPath = await getapiPath();
    final dataString = await http
        .get(Uri.parse(apiPath.trim() + 'exploreapi?book=$book'));
    final Map<String, dynamic> json = jsonDecode(dataString.body);
    //final dataString = await _loadAsset('assets/sample_data/harry_potter.json');

    if (json['books'] != null) {
      final books = <BookData>[];
      json['books'].forEach((book) {
        books.add(BookData.fromJson(book));
      });
      return books;
    } else {
      return [];
    }
  }

  Future<List<BookData>> getLibraryData(String user, String pwd) async {
    final apiPath = await getapiPath();
    final dataString = await http
        .get(Uri.parse(apiPath.trim() + 'getlibrary?u=$user&p=$pwd'));
    final Map<String, dynamic> json = jsonDecode(dataString.body);
    //final dataString = await _loadAsset('assets/sample_data/harry_potter.json');

    if (json['books'] != null) {
      final books = <BookData>[];
      json['books'].forEach((book) {
        books.add(BookData.fromJson(book));
      });
      return books;
    } else {
      return [];
    }
  }

  Future<ProfileData> getProfileData(String user, String pwd) async {
    final apiPath = await getapiPath();
    final dataString = await http
        .get(Uri.parse(apiPath.trim() + 'checklogin?u=$user&p=$pwd'));
    return ProfileData.fromJson(jsonDecode(dataString.body));
  }

  Future<DownloadData> getDlData(String link) async {
    final apiPath = await getapiPath();
    final dataString =
        await http.get(Uri.parse(apiPath.trim() + 'getlinks?link=$link'));
    return DownloadData.fromJson(jsonDecode(dataString.body));
  }

  Future<bool> checkUserExist(String user, String pwd) async {
    final apiPath = await getapiPath();
    final dataString = await http
        .get(Uri.parse(apiPath.trim() + 'checklogin?u=$user&p=$pwd'));
    return jsonDecode(dataString.body).isNotEmpty;
  }

  Future<List<ChatData>> getChatData() async {
    final apiPath = await getapiPath();
    final dataString =
        await http.get(Uri.parse(apiPath.trim() + 'getchats'));
    final Map<String, dynamic> json = jsonDecode(dataString.body);

    if (json['chats'] != null) {
      final chats = <ChatData>[];
      json['chats'].forEach((chat) {
        chats.add(ChatData.fromJson(chat));
      });
      return chats;
    } else {
      return [];
    }
  }

  Future<void> appToCommunity(String UID, String Msg) async {
    final apiPath = await getapiPath();
    await http.get(Uri.parse(apiPath.trim() + 'apptocommunity?u=$UID&msg=$Msg'));
  }

  Future<void> addToLibrary(String bookData, String UID) async {
    final apiPath = await getapiPath();
    await http.get(Uri.parse(apiPath.trim() + 'addtolibfromapp?bookDetails=${bookData.toString()}&UID=$UID'));
  }

  Future<void> removeFromLibrary(String bookData, String UID) async {
    final apiPath = await getapiPath();
    await http.get(Uri.parse(apiPath.trim() + 'removefromlibfromapp?bookDetails=${bookData.toString()}&UID=$UID'));
  }
}
