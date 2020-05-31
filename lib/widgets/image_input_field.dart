import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputField extends FormField<File> {
  ImageInputField({
    FormFieldSetter<File> onSaved,
    FormFieldValidator<File> validator,
    File initialValue,
    bool autovalidate = false
  }): super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<File> state) {
      return Row(
        children: <Widget>[
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey)
            ),
            child: state.value == null 
                    ? Text('No image taken')
                    : Image.file(
                        state.value,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
            alignment: Alignment.center,
          ),
          Expanded(
            child: FlatButton.icon(
              onPressed: () async => {
                _selectImage(state)
              }, 
              icon: Icon(Icons.add_a_photo),
              label: Text('Take/Select Picture'),
              textColor: Theme.of(state.context).primaryColor,
            ),
          ),
        ],
      );
    }
  );

  static Future<void> _selectImage(FormFieldState<File> state) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200
    );
    state.didChange(image);
  }
}