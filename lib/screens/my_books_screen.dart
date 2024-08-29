import 'package:flutter/material.dart';

class MyBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Libros"),
      ),
      body: Center(
        child: Text(
          "Sube tus propios libros en esta sección (funcionalidad futura).",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
