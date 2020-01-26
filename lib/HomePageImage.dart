import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class HomePageImage extends StatefulWidget {
  @override
  _HomePageImageState createState() => _HomePageImageState();
}

class _HomePageImageState extends State<HomePageImage> {
  File imagefile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      imagefile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
//          Image(image: Image.file(imagefile),),
          uploader(file: imagefile),
        ],
      ),
    );
  }
}

class uploader extends StatefulWidget {
  final File file;

  uploader({Key key, @required this.file}) : super(key: key);
  @override
  _uploaderState createState() => _uploaderState();
}

class _uploaderState extends State<uploader> {
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: "gs://fireman-ebb39.appspot.com");

  StorageUploadTask uploadTask;

  void startupload() async {
    String filePath = "images/${DateTime.now()}.png";

    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(widget.file);
      print(uploadTask);
    });

    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    print(downloadUrl);

    final String url = await downloadUrl.ref.getDownloadURL();

    print("URL is: $url");

//    final StorageTaskSnapshot downloadUrl = uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Upload Image"),
            onPressed: startupload,
          ),
        ],
      ),
    );
  }
}
