// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadButton extends StatefulWidget {
  final Function(ImageSource source)? onImageSelected;
  const PhotoUploadButton({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _PhotoUploadButtonState createState() => _PhotoUploadButtonState();
}

class _PhotoUploadButtonState extends State<PhotoUploadButton> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color(0x990000FF),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.white,
                onPressed: () => _getImageFromCamera(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color(0x933066BE),
              ),
              child: IconButton(
                icon: const Icon(Icons.photo),
                color: Colors.white,
                onPressed: () => _getImageFromGallery(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
