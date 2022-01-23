import 'package:flutter/material.dart';
import '../models/models.dart';

class PostCard extends StatelessWidget {
  final ChatData chat;
  const PostCard({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: NetworkImage(chat.pfp),
                      radius: 30,
                    ),
                    Text(chat.author),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(chat.message),
                ),
              ),
            ]),
            Positioned(
              child:
              Text('on ' + chat.timestamp, textAlign: TextAlign.right),
              right: 10,
              bottom: 8,
            )
          ],
        ),
      ),
    );
  }
}
