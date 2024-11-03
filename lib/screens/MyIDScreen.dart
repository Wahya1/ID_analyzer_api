import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "../services/IDAnalyzerService.dart";

class MyIDScreen extends StatefulWidget {
  @override
  _MyIDScreenState createState() => _MyIDScreenState();
}

class _MyIDScreenState extends State<MyIDScreen> {
  File? _documentImage;
  File? _faceImage;

  Future<void> _pickDocumentImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _documentImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickFaceImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _faceImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _analyzeImages() async {
    if (_documentImage != null && _faceImage != null) {
      await IDAnalyzerService().analyzeID(_documentImage!, _faceImage!, "YOUR_PROFILE_ID");
    } else {
      print("Please select both images before analyzing.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ID Analyzer")),
      body: SingleChildScrollView(  // Allows scrolling to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _documentImage != null
                  ? Image.file(_documentImage!)
                  : Text("No document image selected"),
              SizedBox(height: 20),
              _faceImage != null
                  ? Image.file(_faceImage!)
                  : Text("No face image selected"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDocumentImage,
                child: Text("Capture Document Image"),
              ),
              ElevatedButton(
                onPressed: _pickFaceImage,
                child: Text("Capture Face Image"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _analyzeImages,
                child: Text("Analyze ID"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
