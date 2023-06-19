import 'package:flutter/material.dart';
import 'package:book_recognizer_frontend/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (book.thumbnail != '')
              Center(
                child: Image.network(
                  book.thumbnail,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(book.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            book.isEbook
                ? ElevatedButton(
                    onPressed: () => _launchUrl(book.buyLink),
                    child: const Text('Buy eBook'),
                  )
                : const Text('No ebooks available for this volume.',
                    style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
