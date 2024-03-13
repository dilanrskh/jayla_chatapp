import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jayla_chatapp/widget/chat/chat_input_widget.dart';
import 'package:jayla_chatapp/widget/chat/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            items: const [
              DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Logout'),
                    ],
                  ))
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            Expanded(
              child: MessagesWidget(),
            ),
            ChatInputWidget(),
          ],
        ),
      ),
    );
  }
}
