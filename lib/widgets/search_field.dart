import 'package:flutter/material.dart';
import 'package:prixz_test/viewmodels/book_view_model.dart';

class SearchField extends StatelessWidget {
  final BookViewModel bookViewModel;

  const SearchField({Key? key, required this.bookViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Search by title or author",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (query) {
        if (query.isNotEmpty) {
          bookViewModel.searchBooks(query, category: '');
        }
      },
    );
  }
}
