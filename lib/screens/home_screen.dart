import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/services/book_service.dart';
import 'package:prixz_test/widgets/book_card.dart';
import 'package:prixz_test/screens/book_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = const [
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

  final Map<String, String> categoryTitles = const {
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
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Column(
            children: [
              Text(
                'Book Library',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar libros',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onSubmitted: (query) {
                  Navigator.pushNamed(context, '/search', arguments: query);
                },
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategorySection(
              category: categories[index],
              title: categoryTitles[categories[index]]!,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: const Icon(Icons.search),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Ya estás en HomeScreen
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            const SizedBox(width: 48), // Espacio para el FAB
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {
                Navigator.pushNamed(context, '/my_books');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;
  final String title;

  const CategorySection({required this.category, required this.title});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<BookService>(context, listen: false)
          .fetchBooksByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingCategory(title: title);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error cargando $title'),
          );
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return Center(
            child: Text('No se encontraron libros para $title'),
          );
        } else {
          final books = snapshot.data as List<dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                            builder: (context) => BookDetailScreen(
                              book: books[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}

class LoadingCategory extends StatelessWidget {
  final String title;

  const LoadingCategory({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
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
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
