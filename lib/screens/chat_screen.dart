import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../api/megz_readme_api.dart';

final _controller = TextEditingController();

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: MegzReadmeApi().getChatData(),
              builder: (context, AsyncSnapshot<List<ChatData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final chats = snapshot.data ?? [];
                  return ListView.builder(
                    itemBuilder: (context, index){
                      return PostCard(chat: chats[index]);
                    },
                    itemCount: chats.length,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
        TextField(
          controller: _controller,
          onSubmitted: (String msg) async{
            ProfileData getUID = await Provider.of<AppStateManager>(context, listen:false).getProfileFromSession();
            MegzReadmeApi().appToCommunity(getUID.UID, msg);
            _controller.clear();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Send a message...',
          ),
        ),
      ],
    );
  }
}
