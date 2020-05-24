import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  ImageInput({Key key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override

  void _selectImage() {
    
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
          child: Text('No image taken'),
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