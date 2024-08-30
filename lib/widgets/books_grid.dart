import 'package:flutter/material.dart';
import 'package:prixz_test/screens/book_detail_screen.dart';
import 'package:prixz_test/viewmodels/book_view_model.dart';
import 'package:prixz_test/widgets/book_card.dart';

class BooksGrid extends StatelessWidget {
  final BookViewModel bookViewModel;
  final double screenWidth;
  final ScrollController controller;

  const BooksGrid({
    Key? key,
    required this.bookViewModel,
    required this.screenWidth,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: screenWidth > 600 ? 3 / 4 : 4 / 6,
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
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}
