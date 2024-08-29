import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    final coverUrl = book['cover_i'] != null
        ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg'
        : book['cover_id'] != null
            ? 'https://covers.openlibrary.org/b/id/${book['cover_id']}-L.jpg'
            : 'https://via.placeholder.com/120x180.png?text=No+Cover';

    final title = book['title'] ?? 'Título Desconocido';

    String authorName = 'Autor Desconocido';
    if (book['author_name'] != null &&
        (book['author_name'] as List).isNotEmpty) {
      authorName = (book['author_name'] as List).join(', ');
    } else if (book['authors'] != null &&
        (book['authors'] as List).isNotEmpty) {
      final authorsList = book['authors'] as List;
      authorName = authorsList.map((author) => author['name']).join(', ');
    }

    final description = book['description'] is String
        ? book['description']
        : book['description'] is List
            ? (book['description'] as List).join('\n')
            : 'Descripción no disponible.';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implementar función para compartir el libro.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons
                      .error); // Mostrar un ícono de error si la imagen no se carga
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Autor: $authorName',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // función para agregar a favoritos.
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}
