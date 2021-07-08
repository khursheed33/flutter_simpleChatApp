import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/pickers/profile_picture.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFm, this.isLoading);
  final void Function({
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
    File image,
  }) submitFm;
  final bool isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _pickedImage;
  // Get the Image Picked
  void pickedImage(File image) {
    _pickedImage = image;
  }

  // OnSubmit - Validate and Save
  void _submitForm() {
    // print(_pickedImage);
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    // When image not selected - show the snackbar
    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please pick an Image",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
      );
      return;
    }
// When form is valid save the data
    if (_isValid) {
      _formKey.currentState.save();
      widget.submitFm(
        email: _userEmail.trim(),
        username: _userName.trim(),
        password: _userPassword,
        isLogin: _isLogin,
        ctx: context,
        image: _pickedImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLogin)
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      if (_isLogin) Divider(),
                      if (!_isLogin) ProfilePicture(pickedImage),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email ID",
                        ),
                        validator: (value) {
                          if ((value.isEmpty || value.length < 7) &&
                              !(value.contains("@"))) {
                            return "Please enter a valid Email ID";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _userEmail = val;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 3) {
                              return "Please enter a valid Username";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _userName = val;
                          },
                        ),

                      TextFormField(
                        key: ValueKey('password'),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return "Password must have atleast 4+ characters";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _userPassword = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // TextFormField(),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        RaisedButton(
                          onPressed: _submitForm,
                          child: Text(_isLogin ? "Login" : "Sign Up"),
                        ),
                      if (!widget.isLoading)
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? "Create an Account?"
                              : "I already have an account!"),
                        ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
