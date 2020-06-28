import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


enum ImageInputFieldSource  {
  camera,
  gallery,
  url
}
class ImageInputField extends FormField<File> {
  ImageInputField({
    FormFieldSetter<File> onSaved,
    FormFieldValidator<File> validator,
    File initialValue,
    String url,
    bool autovalidate = false
  }): super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<File> state) {

      Future<File> _urlToImage(String url) async {
        final response = await http.get(url);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        final ext = path.extension(url);
        final filename = DateTime.now().millisecondsSinceEpoch.toString();
        File image;
        image = File('$tempPath/$filename$ext');
        image.writeAsBytes(response.bodyBytes);
        return image;
      }

      Future<ImageInputFieldSource> _selectSource() async {
        return await showDialog(
          context: state.context,
          builder: (ctx) => SimpleDialog(
            title: const Text('Choose from'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.of(state.context).pop(ImageInputFieldSource.gallery); },
                child: const Text('Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.of(state.context).pop(ImageInputFieldSource.camera); },
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.of(state.context).pop(ImageInputFieldSource.url); },
                child: const Text('Paste the URL'),
              )
            ],
          )
        );
      }

      Future<String> _getURLDialog() async {
        return await showDialog(
          context: state.context,
          builder: (ctx) => SimpleDialog(
            title: const Text('Paste URL'),
            children: <Widget>[
              SimpleDialogOption(
                child: HttpUrlDialog(
                  onSubmit: (url) => Navigator.of(state.context).pop(url),
                ),
              )
            ],
          )
        );
      }

      Future<void> _selectImage(FormFieldState<File> state) async {
        try {
          File image;
          // show the popup for the source selection
          final selection = await _selectSource();

          if (selection == ImageInputFieldSource.url) {
            final url = await _getURLDialog();
            // show the dialog once again for the url input
            if (url != null) {
              try {
                image = await _urlToImage(url);
              } catch (e) {
                throw(e);
              }
            }
          } else if (selection == ImageInputFieldSource.camera || selection == ImageInputFieldSource.gallery){
            // pick using image picker
            image = await ImagePicker.pickImage(
              source: selection == ImageInputFieldSource.camera ? ImageSource.camera : ImageSource.gallery,
              imageQuality: 50,
              maxWidth: 200
            );
          }
          state.didChange(image);  
        } catch (e) {
          throw(e);
        }
        
      }
      
      print("Url analysed");
      // TODO: Need to implement based on the controller concept like below
      // https://github.com/tshedor/flutter_image_form_field
      // This is temporary
      // TODO: Implement the loader for safe
      if (url != null && state.value == null) {
        print("Url is there ${url}");
        _urlToImage(url).then((File value) {
          print(value);
          state.didChange(value);
        });
      }
      return Column(
        children: <Widget>[
          Row(
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
          ),
          if (state.hasError)
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  state.errorText,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(state.context).errorColor,
                    fontSize: 12
                  )
                ),
              ),
            ),
        ]
      );
    }
  );
}


class HttpUrlDialog extends StatefulWidget {
  final Function onSubmit;
  HttpUrlDialog({Key key, this.onSubmit}) : super(key: key);

  @override
  _HttpUrlDialogState createState() => _HttpUrlDialogState();
}

class _HttpUrlDialogState extends State<HttpUrlDialog> {
  final _form = GlobalKey<FormState>();
  String url;
  
  _saveURL() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    widget.onSubmit(url);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _form,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  onSaved: (value) {
                    url = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an image URL.';
                    }
                    if (!value.startsWith('http') &&
                        !value.startsWith('https')) {
                      return 'Please enter a valid URL.';
                    }
                    if (!value.endsWith('.png') &&
                        !value.endsWith('.jpg') &&
                        !value.endsWith('.jpeg')) {
                      return 'Please enter a valid image URL.';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send), 
                onPressed: () {
                  _saveURL();
                }
              )
            ],
          )
          // child: TextFormField()
        ),
      ),
    );
  }
}