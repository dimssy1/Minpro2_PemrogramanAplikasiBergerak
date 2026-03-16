import 'package:flutter/material.dart';
import 'package:butik_stylish/screens/halaman_produk.dart';
import 'package:butik_stylish/screens/halaman_penjualan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Data produk
  List<Map<String, dynamic>> produkList = [];

  // Data penjualan
  final List<Map<String, dynamic>> dataPenjualan = [];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([HalamanProduk(homeState: this), const HalamanPenjualan()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Kasir"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Penjualan",
          ),
        ],
      ),
    );
  }
}
