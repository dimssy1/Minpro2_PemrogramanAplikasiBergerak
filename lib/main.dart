import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_page.dart'; // Sesuaikan dengan path kamu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://elecezbuzudkxlzwtebi.supabase.co',
    anonKey: 'sb_publishable_rKXTmAhEb780j25pzhZAHg_BfAZW9_D',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butik Stylish',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomePage(),
    );
  }
}
