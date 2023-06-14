import 'package:book_recognizer_frontend/models/book.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<Book> books;

  const ResultsScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: books[index].thumbnail != null
                  ? Image.network(books[index].thumbnail)
                  : null,
              title: Text(books[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (books[index].subtitle != null)
                    Text(books[index].subtitle),
                  if (books[index].authors != null)
                    ...books[index].authors.map((a) => Text(a)).toList(),
                  if (books[index].categories != null)
                    ...books[index].categories.map((c) => Text(c)).toList(),
                ],
              ),
            );
          }),
    );
  }
}
