import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../api/megz_readme_api.dart';

class ExploreScreen extends StatefulWidget {

  ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Expanded searchResults = const Expanded(child: Center(child: Text('Search for something...')));

  final mockService = MegzReadmeApi();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onSubmitted: (String val) {
              setState(() {
                searchResults = Expanded(
                  child: FutureBuilder(
                    future: mockService.getBookData(val),
                    builder: (context, AsyncSnapshot<List<BookData>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final books = snapshot.data ?? [];
                        if (books.isNotEmpty) {
                          return GridView.builder(
                            //scrollDirection: Axis.vertical,
                            //itemCount: books.length~/2,
                            itemCount: books.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.67,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return BookModal(book: books[index]);
                                      },
                                    );
                                  },
                                  child: BookCard(book: books[index], showStar: false));
                            },
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: Image.asset('assets/error.png'),
                              ),
                              const Text('No results were returned! Try again.'),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.cyan,
                                onPressed: () {},
                                child: const Text('Try again!'),
                              )
                            ],
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              });
            },
            cursorColor: Colors.cyan,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
              hintText: 'Search for books...',
              hintStyle: const TextStyle(height: 0.5),
            ),
          ),
        ),
        searchResults
      ],
    );
  }
}
