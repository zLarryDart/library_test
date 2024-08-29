import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: Center(
        child: Text(
          "Aquí aparecerán tus libros favoritos.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
