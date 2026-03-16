import 'package:flutter/material.dart';

class FormInputPakaian extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController brandController;
  final TextEditingController produkController;
  final TextEditingController hargaController;
  final TextEditingController jumlahController;
  final TextEditingController imageUrlController;
  final bool isEditing;
  final VoidCallback onSubmit;

  const FormInputPakaian({
    super.key,
    required this.formKey,
    required this.brandController,
    required this.produkController,
    required this.hargaController,
    required this.jumlahController,
    required this.imageUrlController,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Judul
            Text(
              isEditing ? "Edit Data Penjualan" : "Tambah Data Penjualan",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Field Brand
            TextFormField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: "Nama Brand Baju",
                prefixIcon: Icon(Icons.store),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? "Brand tidak boleh kosong" : null,
            ),
            const SizedBox(height: 12),

            // Field Produk
            TextFormField(
              controller: produkController,
              decoration: const InputDecoration(
                labelText: "Nama Produk",
                prefixIcon: Icon(Icons.checkroom),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? "Produk tidak boleh kosong" : null,
            ),
            const SizedBox(height: 12),

            // Field Harga
            TextFormField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga Satuan",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) return "Harga tidak boleh kosong";
                if (int.tryParse(value) == null) return "Masukkan angka valid";
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Field Jumlah
            TextFormField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Terjual",
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) return "Jumlah tidak boleh kosong";
                if (int.tryParse(value) == null) return "Masukkan angka valid";
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Field Image URL (Opsional)
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: "Link Gambar (Opsional)",
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Submit
            ElevatedButton.icon(
              onPressed: onSubmit,
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? "Simpan Perubahan" : "Tambah Data"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
