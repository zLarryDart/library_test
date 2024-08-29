import 'package:flutter/material.dart';
import 'package:prixz_test/services/book_service.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService = BookService();
  List<dynamic> _books = [];
  bool _isLoading = false;
  int _currentPage = 1;
  String _currentQuery = "";

  List<dynamic> get books => _books;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;

  Future<void> searchBooks(String query,
      {int page = 1, required String category}) async {
    _isLoading = true;
    notifyListeners();

    _currentQuery = query; // Guardar la query actual

    try {
      final results = await _bookService.searchBooks(query, page: page);
      _books = results;
      _currentPage = page;
    } catch (e) {
      // Manejo de errores
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_books.isNotEmpty) {
      // Asegurarse de que hay resultados antes de avanzar
      searchBooks(_currentQuery, page: _currentPage + 1, category: '');
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      searchBooks(_currentQuery, page: _currentPage - 1, category: '');
    }
  }
}
