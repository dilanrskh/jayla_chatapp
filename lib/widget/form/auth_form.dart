// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jayla_chatapp/widget/form/user_image_picker.dart';

class AuthFormWidget extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String UserName,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  const AuthFormWidget({
    Key? key,
    required this.isLoading,
    required this.submitFn,
  }) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  // key untuk form nya
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  // function untuk ambil image
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    // ini buat validasi form key nya, kalau dia valid maka nilainya true
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

// ini kondisi untuk ngecek, user sudah pernah login dan input gambar apa belum
    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tolong Masukkan Gambar dulu !'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

// Ini buat ngecek, apakah form nya valid atau udah keisi atau belum
    if (isValid!) {
      // data yang sudah diisi, di validasi lagi baru di save
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kalau dia regis nanti image pickernya muncul, kalau login gak muncul
                    if (!_isLogin)
                      UserImagePicker(
                          key: UniqueKey(), imagePickFn: _pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Tolong masukkan alamat email yang valid !';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: true,
                        enableSuggestions: false,
                        // ini kalau kondisi ke submit dan ada keadaan yang tidak terpenuhi maka
                        // akan muncul pesan eror
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Masukkan Username Minimal 4 Karakter !';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: "Username"),
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password Minimal 6 Karakter !';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Password"),
                      // biar pw nya secure, berubah jadi bintang bintang
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'Sudah Punya Akun'),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
