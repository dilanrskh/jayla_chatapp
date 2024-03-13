import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jayla_chatapp/screen/auth_screen.dart';
import 'package:jayla_chatapp/screen/chat_screen.dart';
import 'package:jayla_chatapp/screen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyCrUmIDBLpL-XjDPD54mHT_mwRmq04GMPg',
          appId: '1:361445902825:android:8fcc090e27159a3ea9a378',
          messagingSenderId: '361445902825',
          projectId: 'pjschat-70782',
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: snapshot.connectionState != ConnectionState.done
            ? const SplashScreen() 
            : StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
             builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (userSnapshot.hasData) {
                return const ChatScreen();
              }
              return const AuthScreen();
             })
          );
        });
  }
}
