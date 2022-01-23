import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static MaterialPage page(int currentTab){
    return MaterialPage(
      name: ReadmePages.home,
      key: ValueKey(ReadmePages.home),
      child: Home(currentTab: currentTab)
    );
  }

  final int currentTab;
  const Home({Key? key, required this.currentTab}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = <Widget>[
    LibraryScreen(), // Library
    ExploreScreen(), // Explore
    ChatScreen(), // Community
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(builder: (context, tabManager, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Readme - Online Library'),
          actions: [
            Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                child: FutureBuilder(
                  future: Provider.of<AppStateManager>(context, listen: false).getProfileFromSession(),
                  builder: (BuildContext context, AsyncSnapshot<ProfileData> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: Provider.of<AppStateManager>(context, listen: false).isLoggedInAndStoredInSession ? NetworkImage(snapshot.data!.pfp) : AssetImage('assets/off.png') as ImageProvider,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                onTap: () async{
                  if (Provider.of<AppStateManager>(context, listen: false).isLoggedInAndStoredInSession) {
                    Provider.of<AppStateManager>(context, listen: false).tapOnProfile(true);
                  } else {
                    Provider.of<AppStateManager>(context, listen: false).logout();
                  }
                },
              ),
            )
          ],
        ),
        body: pages[widget.currentTab],
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: ConvexAppBar(
          key: tabManager.appBarKey,
          onTap: tabManager.goToTab,
          items: const [
            TabItem(title: 'Library', icon: Icons.local_library),
            TabItem(title: 'Search', icon: Icons.search),
            TabItem(title: 'Community', icon: Icons.people),
          ],
        ),
      );
    });
  }
}
