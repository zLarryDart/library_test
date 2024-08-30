import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/viewmodels/book_view_model.dart';
import 'package:prixz_test/widgets/search_field.dart';
import 'package:prixz_test/widgets/books_grid.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);

    // Añadir un listener al ScrollController para detectar cuando se llega al final del scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !bookViewModel.isLoadingMore) {
        bookViewModel.nextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookViewModel = Provider.of<BookViewModel>(context);
    final String? category =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (category != null && bookViewModel.books.isEmpty) {
      bookViewModel.searchBooks('', category: category);
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(category != null ? "$category Books" : "Book Search"),
      ),
      body: Column(
        children: [
          if (category == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(bookViewModel: bookViewModel),
            ),
          bookViewModel.isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Expanded(
                  child: BooksGrid(
                    bookViewModel: bookViewModel,
                    screenWidth: screenWidth,
                    controller: _scrollController, // Pasamos el controlador
                  ),
                ),
          if (bookViewModel.isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
