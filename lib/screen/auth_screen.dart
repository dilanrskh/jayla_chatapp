import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jayla_chatapp/widget/form/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // ini var buat kalau ada yang login atau regis datanya masuk ke firebase
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      // Kalau misalnya page nya itu login, maka yang dimunculkan page login
      if(isLogin){
        authResult = await  _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        // masuk ke firebase untuk simpan data dan gambar
        final ref  = FirebaseStorage.instance
        .ref()
        // Gambar inputan user bakal tersimpan di folder user_image
        .child('user_image')
        // gambarnya di kasih id pake uid(user id), ambil gambarnya dalam format url
        .child(authResult.user!.uid + '.jpg');

        // gambarnya tinggal di put  
        await ref.putFile(image!);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set({'username': username, 'email': email, 'image_url': url});
      }
    } on PlatformException catch (err) {
      var msg = 'Please Check your credential';
      if(err.message != null) {
        msg = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(isLoading: _isLoading, submitFn: _submitAuthForm),
    );
  }
}