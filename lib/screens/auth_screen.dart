import 'dart:io';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitFormData({
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
    File image,
  }) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //  Login
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        //  Sign Up
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        /*  Adding Profile picture to Storage - It's doing here because we need image url in Firestore to fetch the profile picture */
        final refImg = FirebaseStorage.instance
            .ref()
            .child("user_profiles")
            .child(userCredential.user.uid + '.jpg');
        // Putting file to the Storage
        await refImg.putFile(image).whenComplete(
              () => print("Upload Completed"),
            );

        // Get the Image URL
        final String imageUrl = await refImg.getDownloadURL();
        // Adding extra information to the firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': imageUrl,
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occured. Please check your Credentials";
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
        ),
      );
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, streamData) {
          if (streamData.hasData) {
            return ChatScreen();
          }
          return AuthForm(_submitFormData, _isLoading);
        },
      ),
    );
  }
}
