import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../api/megz_readme_api.dart';
import 'dart:io';

class BookScreen extends StatelessWidget {
  String bookMirror;
  bool isURL;

  static MaterialPage page(bookMirror, isURL) {
    return MaterialPage(
        name: ReadmePages.book,
        key: ValueKey(ReadmePages.book),
        child: BookScreen(
          bookMirror: bookMirror,
          isURL: isURL,
        ));
  }

  BookScreen({Key? key, required this.bookMirror, required this.isURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MegzReadmeApi().getDlData(bookMirror),
        builder: (context, AsyncSnapshot<DownloadData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return isURL ?
              SfPdfViewer.network(snapshot.data!.cloudflare)
              : SfPdfViewer.file(File(bookMirror));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
