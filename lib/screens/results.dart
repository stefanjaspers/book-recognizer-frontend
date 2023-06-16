import 'package:book_recognizer_frontend/models/book.dart';
import 'package:flutter/material.dart';
import 'package:book_recognizer_frontend/screens/book_details.dart';

class ResultsScreen extends StatelessWidget {
  final List<Book> books;

  const ResultsScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(book: books[index]),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(books[index].thumbnail)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              books[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...books[index]
                                .authors
                                .map((a) => Text(a,
                                    style: const TextStyle(fontSize: 18)))
                                .toList(),
                            ...books[index]
                                .categories
                                .map((c) => Text(c,
                                    style: const TextStyle(fontSize: 18)))
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
