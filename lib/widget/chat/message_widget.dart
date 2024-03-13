import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jayla_chatapp/widget/chat/bubble_widget.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  @override
  Widget build(BuildContext context) {
    // buat ambil data user dari firebase
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            // descending biar data yang terakhir ada di paling atas
            .orderBy('createdAt', descending: true)
            // buat dapetin data chat nya
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
                parent: const BouncingScrollPhysics()),
            // biar nanti kalau data chat terbaru dia ada di paling bawah
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              // bikijn dulu bubble widget
              // baru pasang bubble widget
              return BubbleChatWidget(
                // data nya ubah ke map habis itu buat message nya kita pakein key text
                message: (chatDocs[index].data()! as Map)['text'],
                 userName: (chatDocs[index].data()! as Map)['username'], 
                 userImage: (chatDocs[index].data()! as Map)['userImage'], 
                //  buat ngecek apakah user id nya sama apa gak dengan user yang ada di lokal kalau iya kan berarti isme
                 isMe: (chatDocs[index].data()! as Map)['userId'] == user!.uid);
            },
          );
        });
  }
}
