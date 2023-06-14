class Book {
  final String title;
  final List<String> authors;
  final List<String> categories;
  final String description;
  final String thumbnail;
  final bool isEbook;
  final String? buyLink;

  Book({
    required this.title,
    required this.authors,
    required this.categories,
    required this.description,
    required this.thumbnail,
    required this.isEbook,
    this.buyLink,
  });

  factory Book.fromJson(
      Map<String, dynamic> volumeInfo, Map<String, dynamic> saleInfo) {
    print('volumeInfo: $volumeInfo'); // New print statement
    print('saleInfo: $saleInfo'); // New print statement

    return Book(
      title: volumeInfo['title'] ?? 'No title',
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      description: volumeInfo['description'] ?? 'No description',
      thumbnail: volumeInfo['imageLinks'] != null
          ? volumeInfo['imageLinks']['thumbnail']
          : 'No thumbnail',
      isEbook: saleInfo['isEbook'] ?? false,
      buyLink: saleInfo['buyLink'],
    );
  }
}
