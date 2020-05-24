import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  ImageInput({Key key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;

  Future<void> _selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey)
          ),
          child: _image == null 
                  ? Text('No image taken')
                  : Image.file(
                      _image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
          alignment: Alignment.center,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: _selectImage, 
            icon: Icon(Icons.add_a_photo),
            label: Text('Take/Select Picture'),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}