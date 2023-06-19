import 'package:book_recognizer_frontend/models/book.dart';
import 'package:flutter/material.dart';
import 'package:book_recognizer_frontend/screens/book_details.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (books[index].thumbnail != '')
                      Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: Image.network(
                          books[index].thumbnail,
                          width: 100, // adjust the width as needed
                          height: 100, // adjust the height as needed
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index].title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Authors:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ...books[index]
                              .authors
                              .map((a) => Text(
                                    a,
                                    style: const TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                          const SizedBox(height: 10),
                          const Text(
                            'Genres:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ...books[index]
                              .categories
                              .map((c) => Text(
                                    c,
                                    style: const TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
