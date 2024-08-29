import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/services/book_service.dart';
import 'package:prixz_test/widgets/book_card.dart';
import 'package:prixz_test/screens/book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = [
    'classics',
    'loved',
    'romantic',
    'children',
    'suspense',
    'mystery',
    'fantasy',
    'adventure',
    'horror',
    'science_fiction',
  ];

  final Map<String, String> categoryTitles = {
    'classics': 'Libros Clásicos',
    'loved': 'Libros que Amamos',
    'romantic': 'Romántico',
    'children': 'Infantil',
    'suspense': 'Suspenso',
    'mystery': 'Misterio',
    'fantasy': 'Fantasía',
    'adventure': 'Aventura',
    'horror': 'Terror',
    'science_fiction': 'Ciencia Ficción',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Library"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategorySection(context, categories[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.search),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Ya estás en HomeScreen
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            SizedBox(width: 48), // Espacio para el FAB
            IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () {
                Navigator.pushNamed(context, '/my_books');
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String category) {
    return FutureBuilder(
      future: Provider.of<BookService>(context, listen: false)
          .fetchBooksByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCategory(category);
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error cargando ${categoryTitles[category]}'));
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return Center(
              child: Text(
                  'No se encontraron libros para ${categoryTitles[category]}'));
        } else {
          final books = snapshot.data as List<dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryTitles[category]!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return BookCard(
                      book: books[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookDetailScreen(book: books[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }

  Widget _buildLoadingCategory(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryTitles[category]!,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Número de placeholders
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 10),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
