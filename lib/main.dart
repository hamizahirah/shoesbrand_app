import 'package:flutter/material.dart';
import 'package:shoesbrand/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Brand Manager',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.tealAccent),
      ),
      home: const HomePage(), // Sets the HomePage as the initial screen
    );
  }
}
