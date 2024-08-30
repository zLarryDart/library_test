import 'package:flutter/material.dart';
import 'package:prixz_test/services/book_service.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _bookService = BookService();
  List<dynamic> _books = [];
  bool _isLoading = false;
  bool _isLoadingMore = false; // Nueva bandera para la carga de más datos
  int _currentPage = 1;
  String _currentQuery = "";

  List<dynamic> get books => _books;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore; // Getter para la nueva bandera
  int get currentPage => _currentPage;

  Future<void> searchBooks(String query,
      {int page = 1, required String category}) async {
    _isLoading = true;
    notifyListeners();

    _currentQuery = query;

    try {
      final results = await _bookService.searchBooks(query, page: page);
      _books = results;
      _currentPage = page;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    if (_books.isNotEmpty) {
      _isLoadingMore = true;
      notifyListeners();

      try {
        final results = await _bookService.searchBooks(_currentQuery,
            page: _currentPage + 1);
        _books.addAll(results);
        _currentPage++;
      } catch (e) {
        print(e);
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }
}
