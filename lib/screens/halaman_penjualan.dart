import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';
import 'package:butik_stylish/services/pakaian_service.dart';

class HalamanPenjualan extends StatefulWidget {
  const HalamanPenjualan({super.key});

  @override
  State<HalamanPenjualan> createState() => _HalamanPenjualanState();
}

class _HalamanPenjualanState extends State<HalamanPenjualan> {
  final _formKey = GlobalKey<FormState>();
  final pakaianService = PakaianService();

  List<Map<String, dynamic>> listPenjualan = [];

  final TextEditingController brandController = TextEditingController();
  final TextEditingController produkController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  bool isEditing = false;
  int? editId; // Menggunakan ID dari Supabase, bukan index local

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    final data = await pakaianService.getPenjualan();
    setState(() {
      listPenjualan = data;
    });
  }

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      int harga = int.parse(hargaController.text);
      int jumlah = int.parse(jumlahController.text);

      final data = {
        "brand": brandController.text,
        "produk": produkController.text,
        "harga": harga,
        "jumlah": jumlah,
        "total": harga * jumlah,
        "tanggal": DateTime.now().toString().split(' ')[0],
      };

      if (isEditing && editId != null) {
        await pakaianService.updatePenjualan(editId!, data);
      } else {
        await pakaianService.tambahPenjualan(data);
      }

      _clearControllers();
      Navigator.pop(context);
      refreshData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                isEditing ? "Data diupdate" : "Transaksi berhasil disimpan")),
      );
    }
  }

  void prepareEdit(Map<String, dynamic> item) {
    setState(() {
      isEditing = true;
      editId = item['id'];
      brandController.text = item["brand"];
      produkController.text = item["produk"];
      hargaController.text = item["harga"].toString();
      jumlahController.text = item["jumlah"].toString();
    });
    tampilForm();
  }

  void _clearControllers() {
    brandController.clear();
    produkController.clear();
    hargaController.clear();
    jumlahController.clear();
    isEditing = false;
    editId = null;
  }

  // --- UI WIDGETS ---

  void tampilForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isEditing ? "✏️ Edit Transaksi" : "➕ Tambah Transaksi",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: "Brand")),
                TextFormField(
                    controller: produkController,
                    decoration: const InputDecoration(labelText: "Produk")),
                TextFormField(
                    controller: hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Harga")),
                TextFormField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Jumlah")),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  child:
                      Text(isEditing ? "Simpan Perubahan" : "Simpan Transaksi"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPendapatan =
        listPenjualan.fold(0, (sum, item) => sum + (item['total'] as int));

    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Penjualan Supabase")),
      body: Column(
        children: [
          // Header Statistik
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pendapatan:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(FormatRupiah.toRupiah(totalPendapatan),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // List Data
          Expanded(
            child: listPenjualan.isEmpty
                ? const Center(child: Text("Belum ada transaksi"))
                : ListView.builder(
                    itemCount: listPenjualan.length,
                    itemBuilder: (context, index) {
                      final item = listPenjualan[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text("${item['brand']} - ${item['produk']}"),
                          subtitle: Text(
                              "${item['jumlah']} pcs x ${FormatRupiah.toRupiah(item['harga'])}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(FormatRupiah.toRupiah(item['total']),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                              IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () => prepareEdit(item)),
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await pakaianService
                                        .hapusPenjualan(item['id']);
                                    refreshData();
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearControllers();
          tampilForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
