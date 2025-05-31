// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/welcome_page.dart'; // Pastikan file ini ada di lib/pages/
import 'providers/cart_provider.dart'; // Pastikan file ini ada di lib/providers/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( 
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Pemesanan Ikan App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const WelcomePage(),
      ),
    );
  }
}