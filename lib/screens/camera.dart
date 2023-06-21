import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:book_recognizer_frontend/models/book.dart';
import 'package:book_recognizer_frontend/screens/results.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  bool _isLoading = false;

  String getBackendUrl() {
    // if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:8000';
    // } else {
    //   return 'http://localhost:8000';
    // }

    return 'http://18.135.170.219:80';
  }

  Future<void> _navigateToResults(String responseBody) async {
    final List<dynamic> responseList = json.decode(responseBody);

    List<Book> books = [];

    for (final responseItem in responseList) {
      final Map<String, dynamic> decodedJson = responseItem;
      final List<dynamic>? items = decodedJson['items'];

      if (items != null) {
        for (var bookJson in items) {
          final Map<String, dynamic> volumeInfo =
              (bookJson as Map<String, dynamic>)['volumeInfo'];
          final Map<String, dynamic> saleInfo = (bookJson)['saleInfo'];
          Book book = Book.fromJson(volumeInfo, saleInfo);
          books.add(book);
        }
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(books: books),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  Future<void> _sendImageToBackend() async {
    if (_image == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final backendUrl = getBackendUrl();

    // Replace with your backend API URL
    final String apiUrl = '$backendUrl/books/recognize';

    // Prepare the image file for upload
    final imageBytes = await _image!.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    // Send the image to the backend API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'image': base64Image}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _navigateToResults(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Recognizing books - Please wait.'),
                ],
              )
            : _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : _getImage, // Disable the button when _isLoading is true
        tooltip: 'Pick Image',
        foregroundColor:
            _isLoading ? Colors.grey : Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: _isLoading
                  ? null
                  : _getImageFromGallery, // Disable the button when _isLoading is true
              child: const Text('Select from Gallery'),
            ),
            TextButton(
              onPressed:
                  _image == null || _isLoading ? null : _sendImageToBackend,
              child: const Text('Send Image'),
            ),
          ],
        ),
      ),
    );
  }
}
