import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';

class TotalPendapatan extends StatelessWidget {
  final int totalKeseluruhan;

  const TotalPendapatan({super.key, required this.totalKeseluruhan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        border: Border(
          top: BorderSide(color: Colors.deepPurple[300]!, width: 1),
        ),
      ),
      child: Text(
        "Total Semua Penjualan: ${FormatRupiah.toRupiah(totalKeseluruhan)}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
