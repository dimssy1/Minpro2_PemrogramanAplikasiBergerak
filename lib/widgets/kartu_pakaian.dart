import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';

class KartuPakaian extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const KartuPakaian({
    super.key,
    required this.data,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: () => onEdit(index),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data["imageUrl"],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Detail Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["brand"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data["produk"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildChip(
                          Icons.attach_money,
                          FormatRupiah.toRupiah(data["harga"]),
                        ),
                        const SizedBox(width: 8),
                        _buildChip(Icons.shopping_bag, "${data["jumlah"]} pcs"),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total: ${FormatRupiah.toRupiah(data["total"])}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Hapus
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
