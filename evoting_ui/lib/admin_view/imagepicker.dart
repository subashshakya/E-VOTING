import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';

class ImageTest extends StatefulWidget {
  const ImageTest({super.key});

  @override
  State<ImageTest> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  File? _image;

  Future getImage() async {
    //can be used within the try catch block
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    final imageFile = File(image!.path);

    final imageBytes = await imageFile.readAsBytes();

    final base64 = base64Encode(imageBytes);
    if (image == null) return;

    final imageTemp = File(image.path);
    print('yooo hooo${image.path}');
    // yooo hooo/data/user/0/com.example.evoting_ui/cache/image_picker670193002802722429.jpg
    setState(() {
      this._image = imageTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('pick an image')),
        body: Column(children: <Widget>[
          _image != null
              ? Image.file(
                  _image!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://imgs.search.brave.com/ezeK_LgyIh05VTVhYd9at_gB4KnV58WVmQH3Ql3pG_I/rs:fit:759:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5S/QmVYc2lsaUozcDFI/V3JFTDI0c2tRSGFF/byZwaWQ9QXBp'),
          // Image.network(src),
          customButton(title: 'Pick image', onClick: getImage)
        ]));
  }
}

Widget customButton({required String title, required VoidCallback onClick}) {
  return Container(
      width: 200,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(children: <Widget>[Icon(Icons.image_outlined), Text(title)]),
      ));
}
