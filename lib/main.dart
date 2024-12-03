import 'package:colorz/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ColorZ());
}

class ColorZ extends StatelessWidget {
  const ColorZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
