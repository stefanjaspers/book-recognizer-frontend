class Book {
  final String title;
  final List<String> authors;
  final List<String> categories;
  final String thumbnail;
  final String description;
  final bool isEbook;
  final String buyLink;

  Book(
      {required this.title,
      required this.authors,
      required this.categories,
      required this.thumbnail,
      required this.description,
      required this.isEbook,
      required this.buyLink});

  factory Book.fromJson(
      Map<String, dynamic> volumeInfo, Map<String, dynamic> saleInfo) {
    return Book(
      title: volumeInfo['title'],
      authors: List<String>.from(volumeInfo['authors'] ?? []),
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      thumbnail: volumeInfo['imageLinks'] != null
          ? volumeInfo['imageLinks']['thumbnail']
          : '',
      description: volumeInfo['description'] ?? '',
      isEbook: saleInfo['isEbook'] ?? false,
      buyLink: saleInfo['buyLink'] ?? '',
    );
  }
}
