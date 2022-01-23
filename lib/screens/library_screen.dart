import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../api/megz_readme_api.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  ValueNotifier<double> _notifier = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return Provider.of<AppStateManager>(context, listen: false).isLoggedInAndStoredInSession
        ? FutureBuilder(
            future: Provider.of<AppStateManager>(context, listen: false).getProfileFromSession(),
            builder: (BuildContext context, AsyncSnapshot<ProfileData> snapshotProfile) {
              if (snapshotProfile.connectionState == ConnectionState.done) {
                return FutureBuilder(
                  future: MegzReadmeApi().getLibraryData(snapshotProfile.data!.UID, snapshotProfile.data!.pwd),
                  builder: (context, AsyncSnapshot<List<BookData>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final books = snapshot.data ?? [];
                      if (books.isNotEmpty) {
                        return Column(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _notifier,
                              builder: (BuildContext context, double value, Widget? child) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: LinearProgressIndicator(value: value),
                                );
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: books.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      BookCard(book: books[index], showStar: false),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 6.0),
                                          child: Column(
                                            children: [
                                              LibrarySelectedBookInfo(book: books[index]),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  !File('/storage/emulated/0/Android/data/megh.cs.readme/files/${books[index].Title.replaceAll(' ', '_')}.${books[index].Extension}').existsSync()
                                                      ? FutureBuilder(
                                                          future: MegzReadmeApi().getDlData(books[index].Mirror_1),
                                                          builder: (BuildContext context, AsyncSnapshot<DownloadData> snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.done) {
                                                              return ElevatedButton(
                                                                onPressed: () async {
                                                                  var status = await Permission.storage.request();
                                                                  if (status.isGranted) {
                                                                    final downloaderUtils = DownloaderUtils(
                                                                      progressCallback: (rec, total) {
                                                                        double progress = rec / total;
                                                                        _notifier.value = progress;
                                                                      },
                                                                      file: File(
                                                                          '/storage/emulated/0/Android/data/megh.cs.readme/files/${books[index].Title.replaceAll(' ', '_')}.${books[index].Extension}'),
                                                                      progress: ProgressImplementation(),
                                                                      onDone: () {},
                                                                      deleteOnCancel: true,
                                                                    );
                                                                    if (snapshot.data!.infura.isNotEmpty) await Flowder.download(snapshot.data!.infura, downloaderUtils);
                                                                  } else if (status.isPermanentlyDenied) {
                                                                    await openAppSettings();
                                                                  } else if (status.isDenied) {
                                                                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                                                    ScaffoldMessenger.of(context)
                                                                        .showSnackBar(const SnackBar(content: Text('Storage access denied!'), duration: Duration(milliseconds: 500)));
                                                                  }
                                                                },
                                                                child: const Text('Download'),
                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                                                              );
                                                            } else {
                                                              return const Center(child: CircularProgressIndicator());
                                                            }
                                                          },
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            Provider.of<AppStateManager>(context, listen: false).changeBookState(true,
                                                                '/storage/emulated/0/Android/data/megh.cs.readme/files/${books[index].Title.replaceAll(' ', '_')}.${books[index].Extension}', false);
                                                          },
                                                          child: const Text('Open'),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(Colors.amber),
                                                          ),
                                                        ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      ProfileData getUID = await Provider.of<AppStateManager>(context, listen: false).getProfileFromSession();
                                                      MegzReadmeApi().removeFromLibrary(books[index].toString(), getUID.UID);
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from Library!'), duration: Duration(milliseconds: 500)));
                                                    },
                                                    child: const Text('Remove'),
                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(64.0),
                              child: Image.asset('assets/empty.png'),
                            ),
                            const Text('There are no books saved in your library!'),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.cyan,
                              onPressed: () {
                                Provider.of<AppStateManager>(context, listen: false).goToTab(1);
                                Provider.of<AppStateManager>(context, listen: false).appBarKey.currentState?.animateTo(1);
                              },
                              child: const Text('Add some books!'),
                            )
                          ],
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        : const Center(child: Text('You don\'t have an account here!'));
  }
}
