import 'package:flutter/material.dart';
import 'package:prixz_test/screens/book_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/viewmodels/book_view_model.dart';
import 'package:prixz_test/widgets/book_card.dart';

class BookSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookViewModel = Provider.of<BookViewModel>(context);
    final String? category =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (category != null && bookViewModel.books.isEmpty) {
      bookViewModel.searchBooks('', category: category);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category != null ? "$category Books" : "Book Search"),
      ),
      body: Column(
        children: [
          if (category == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search by title or author",
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    bookViewModel.searchBooks(query, category: '');
                  }
                },
              ),
            ),
          bookViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 4 / 6, // Proporción ajustada
                    ),
                    itemCount: bookViewModel.books.length,
                    itemBuilder: (context, index) {
                      final book = bookViewModel.books[index];
                      return BookCard(
                        book: book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailScreen(book: book),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: bookViewModel.currentPage > 1
                      ? () {
                          bookViewModel.previousPage();
                        }
                      : null,
                  child: Text("Previous"),
                ),
                Text("Page ${bookViewModel.currentPage}"),
                ElevatedButton(
                  onPressed: () {
                    bookViewModel.nextPage();
                  },
                  child: Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
