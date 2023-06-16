import 'package:flutter_test/flutter_test.dart';
import 'package:book_recognizer_frontend/providers/genres_provider.dart';

void main() {
  group('Genres Provider', () {
    test('genres list should not be empty', () {
      expect(genres, isNotEmpty);
    });

    test('genres list should have correct number of elements', () {
      expect(genres.length, 53);
    });

    test('genres list should not contain duplicates', () {
      final uniqueGenres = genres.toSet();
      expect(uniqueGenres.length, genres.length);
    });
  });
}
