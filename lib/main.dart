import 'package:flutter/material.dart';
import 'models/models.dart';
import 'package:provider/provider.dart';
import 'navigation/app_router.dart';

void main() async{
  runApp(const ReadmeApp());
}

class ReadmeApp extends StatefulWidget {
  const ReadmeApp({Key? key}) : super(key: key);

  @override
  _ReadmeAppState createState() => _ReadmeAppState();
}

class _ReadmeAppState extends State<ReadmeApp> {
  final _appStateManager = AppStateManager();
  late AppRouter _appRouter;

  @override
  void initState(){
    super.initState();
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readme - Online Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => _appStateManager),
        ],
        child: Consumer<AppStateManager>(
          builder: (context, appStateManager, child) {
            return MaterialApp(
              title: 'Readme - Online Library',
              home: Router(
                routerDelegate: _appRouter,
                backButtonDispatcher: RootBackButtonDispatcher(),
              ),
            );
          }
        ),
      ),
    );
  }
}
