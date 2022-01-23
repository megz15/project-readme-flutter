import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../api/megz_readme_api.dart';

class BookModal extends StatelessWidget {
  final BookData book;
  BookModal({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 5,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  book.Title + ' by ' + book.Author.replaceAll(',', ', '),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FixedColumnWidth(10),
                  2: IntrinsicColumnWidth(),
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
          FutureBuilder(
              future: MegzReadmeApi().getDlData(book.Mirror_1),
              builder: (context, AsyncSnapshot<DownloadData> snapshot) {
                if (snapshot.connectionState == ConnectionState.done){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        ProfileData getUID = await Provider.of<AppStateManager>(context, listen:false).getProfileFromSession();
                        MegzReadmeApi().addToLibrary(book.toString(), getUID.UID);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Added to Library!'),
                            duration: Duration(milliseconds: 500)));
                      },
                      child: Text('Add to Library'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<AppStateManager>(context, listen: false).changeBookState(true, book.Mirror_1, true);
                      },
                      child: Text('Read Now'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber)),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Download'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightGreen)),
                    ),
                  ],
                );} else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}
