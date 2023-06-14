import 'package:book_recognizer_frontend/models/book.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<Book> books;

  const ResultsScreen({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            leading: book.thumbnailUrl.isNotEmpty
                ? Image.network(book.thumbnailUrl)
                : null,
            title: Text(book.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.subtitle.isNotEmpty) Text(book.subtitle),
                Text('Authors: ${book.authors.join(', ')}'),
                Text('Categories: ${book.categories.join(', ')}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
