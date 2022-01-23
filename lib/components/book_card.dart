import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../components/components.dart';

class BookCard extends StatefulWidget {
  final BookData book;
  final bool showStar;
  const BookCard({
    Key? key,
    required this.book,
    this.showStar = true
  }) : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _visibleOverlay = false;
  bool _isAddedToLibrary = false;

  void _toggleOverlay() {
    setState(() {
      _visibleOverlay = !_visibleOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.45;
    return Listener(
      onPointerHover: (t) {
        _toggleOverlay();
      },
      onPointerUp: (t) {
        _toggleOverlay();
      },
      child: Container(
        height: width * 3/2,
        width: width,
        margin: const EdgeInsets.all(8.0),
        //padding: const EdgeInsets.all(8.0),
        //constraints: const BoxConstraints.expand(width: 180, height: height),
        /*decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.book.img),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),*/
        child: Stack(
          children: [
            buildFadeInImage(widget.book.img,
                buildFadeInImage(widget.book.img.replaceAll('-d', '-g'),
                  buildFadeInImage(widget.book.img.replaceAll('-d', '').replaceAll('-g', ''),
                    Image.asset('assets/404.png')))),
            Visibility(
              visible: widget.showStar,
              child: Positioned(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    splashRadius: 1,
                    onPressed: () {
                      setState(() {
                        _isAddedToLibrary = !_isAddedToLibrary;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Added to Library'),
                          duration: Duration(milliseconds: 500)));
                    },
                    icon: Icon(
                        _isAddedToLibrary ? Icons.star : Icons.star_border),
                  ),
                ),
                right: 0,
              ),
            ),
            Visibility(
              visible: _visibleOverlay,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    //width: double.infinity,
                    height: 140,
                    color: Colors.black.withOpacity(0.7),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            truncateWithEllipsis(40, widget.book.Title) +
                                "\n\nby ${truncateWithEllipsis(40, widget.book.Author.replaceAll(',', ', '))}\n\n" +
                                widget.book.Size.toUpperCase() +
                                ', ' +
                                widget.book.Extension,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildFadeInImage(String url, Widget onError) => FadeInImage(
    image: NetworkImage(url),
    placeholder: AssetImage('assets/404.png'),
    imageErrorBuilder:
        (context, error, stackTrace) {
      return onError;
    },
    fit: BoxFit.fitWidth,
  );
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
