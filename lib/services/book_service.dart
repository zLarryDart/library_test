import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = 'https://openlibrary.org';

  // Método para buscar libros de manera general
  Future<List<dynamic>> searchBooks(String query,
      {int page = 1, int limit = 10}) async {
    final offset = (page - 1) * limit;
    final response = await http.get(
        Uri.parse('$baseUrl/search.json?q=$query&offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[
          'docs']; // Ajusta esto según la estructura de datos devuelta por la API
    } else {
      throw Exception('Error fetching books');
    }
  }

  // Método para obtener libros por categoría
  Future<List<dynamic>> fetchBooksByCategory(String category,
      {int limit = 10}) async {
    final response = await http
        .get(Uri.parse('$baseUrl/subjects/$category.json?limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[
          'works']; // Ajusta esto según la estructura de datos devuelta por la API
    } else {
      throw Exception('Error fetching books for category $category');
    }
  }

  // Método para obtener la URL de la portada de un libro
  String getBookCoverUrl(String coverId) {
    return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
  }
}
