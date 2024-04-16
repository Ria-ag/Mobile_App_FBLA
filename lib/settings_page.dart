import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileapp/main.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: context.read<MyAppState>().nameController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: _image == null
                    ? const Text('No image selected')
                    : Image.file(_image!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: FloatingActionButton(
                  onPressed: () => getImage(ImageSource.gallery),
                  tooltip: 'Pick Image',
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: FloatingActionButton(
                  onPressed: () => getImage(ImageSource.camera),
                  tooltip: 'Capture Image',
                  child: const Icon(Icons.camera),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    setState(() {
      _image = File(image.path);
    });
  }
}
