import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  ProfilePicture(this.pickImageFn);
  final Function(File image) pickImageFn;
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File _pickedImage;
// Get The Picked Image
  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );

    setState(() {
      if (pickedImage != null) {
        _pickedImage = File(pickedImage.path);
      } else {
        print("Not Selected");
      }
    });

    widget.pickImageFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              backgroundImage:
                  _pickedImage != null ? FileImage(_pickedImage) : null,
              radius: 50,
              child: _pickedImage == null
                  ? Icon(
                      Icons.camera_outlined,
                      size: 50,
                    )
                  : Container(),
            ),
          ),
          FlatButton.icon(
            onPressed: _getImage,
            icon: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              "Take a Picture",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
