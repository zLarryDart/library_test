import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prixz_test/services/book_service.dart';
import 'package:prixz_test/viewmodels/book_view_model.dart';
import 'package:prixz_test/screens/home_screen.dart';
import 'package:prixz_test/screens/login_screen.dart';
import 'package:prixz_test/screens/registration_screen.dart';
import 'package:prixz_test/screens/book_search_screen.dart';
import 'package:prixz_test/screens/book_detail_screen.dart';
import 'package:prixz_test/screens/favorites_screen.dart';
import 'package:prixz_test/screens/my_books_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<BookService>(create: (_) => BookService()),
        ChangeNotifierProvider<BookViewModel>(
          create: (_) => BookViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegistrationScreen(),
        '/search': (context) => BookSearchScreen(),
        '/favorites': (context) => FavoritesScreen(),
        '/my_books': (context) => MyBooksScreen(),
        '/book_details': (context) => BookDetailScreen(
              book: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
    );
  }
}
