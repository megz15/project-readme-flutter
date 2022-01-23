import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class ProfileScreen extends StatefulWidget {
  static MaterialPage page(Future<ProfileData> profileData) {
    return MaterialPage(name: ReadmePages.profilePath, key: ValueKey(ReadmePages.profilePath), child: ProfileScreen(profileData: profileData));
  }

  final Future<ProfileData> profileData;
  const ProfileScreen({Key? key, required this.profileData}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<AppStateManager>(context, listen: false).tapOnProfile(false);
          },
        ),
      ),
      body: FutureBuilder(
        future: widget.profileData,
        builder: (BuildContext context, AsyncSnapshot<ProfileData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.transparent,
                    //backgroundImage: NetworkImage(snapshot.data!.pfp),
                    child: Image.network(snapshot.data!.pfp),
                  ),
              ),
              ListTile(title: Text('Hello, ${snapshot.data!.fName}')),
              ListTile(title: Text('Your username: ' + snapshot.data!.uName)),
              ListTile(title: Text('Account creation date:\n' + DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.timestamp) * 1000).toString())),
              ListTile(
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Provider.of<AppStateManager>(context, listen: false).tapOnProfile(false);
                  Provider.of<AppStateManager>(context, listen: false).logout();
                },
              ),
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
