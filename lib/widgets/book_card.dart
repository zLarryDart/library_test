import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/services/book_service.dart';

class BookCard extends StatelessWidget {
  final dynamic book;
  final VoidCallback? onTap;

  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bookService = Provider.of<BookService>(context, listen: false);

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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width:
              120, // Ajustar el ancho para asegurar que el contenido se ajuste
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 165,
                child: Center(
                  // Centro el contenido del contenedor
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      coverUrl,
                      fit: BoxFit
                          .contain, // Se centra y escala la imagen sin recortarla
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      12, // Ajustar el tamaño de fuente para evitar overflow
                ),
              ),
              SizedBox(height: 4),
              Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize:
                      10, // Reducir el tamaño de fuente para evitar overflow
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
