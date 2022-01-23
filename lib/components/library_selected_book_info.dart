import 'package:flutter/material.dart';
import '../models/models.dart';

class LibrarySelectedBookInfo extends StatelessWidget {
  final BookData book;
  const LibrarySelectedBookInfo({Key? key, required this.book}) : super(key: key);

  factory LibrarySelectedBookInfo.hardcoded(
      author, year, size, language, title, extension, publisher, pages) {
    return LibrarySelectedBookInfo(
      book: BookData(
        Author: author,
        Year: year,
        Size: size,
        Language: language,
        Title: title,
        Extension: extension,
        Publisher: publisher,
        Pages: pages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(book.Title + ' by ' + book.Author),
          ),
        ),
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FixedColumnWidth(10),
                2: FlexColumnWidth(),
              },
              //border: TableBorder.all(color: Colors.grey),
              children: [
                TableRow(children: [
                  Text('Size'),
                  Text(':'),
                  Text(book.Size),
                ]),
                TableRow(children: [
                  Text('Extension '),
                  Text(':'),
                  Text(book.Extension),
                ]),
                TableRow(children: [
                  Text('Publisher'),
                  Text(':'),
                  Text(book.Publisher),
                ]),
                TableRow(children: [
                  Text('Year'),
                  Text(':'),
                  Text(book.Year),
                ]),
                TableRow(children: [
                  Text('Pages'),
                  Text(':'),
                  Text(book.Pages),
                ]),
                TableRow(children: [
                  Text('Language '),
                  Text(':'),
                  Text(book.Language),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
