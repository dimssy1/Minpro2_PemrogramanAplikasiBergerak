import 'package:flutter/material.dart';
import 'package:butik_stylish/utils/format_rupiah.dart';
import 'package:butik_stylish/screens/home_page.dart';
import 'package:butik_stylish/services/pakaian_service.dart';

class HalamanProduk extends StatelessWidget {
  final HomePageState homeState;

  const HalamanProduk({super.key, required this.homeState});

  @override
  Widget build(BuildContext context) {
    return HalamanProdukWidget(homeState: homeState);
  }
}

class HalamanProdukWidget extends StatefulWidget {
  final HomePageState homeState;

  const HalamanProdukWidget({super.key, required this.homeState});

  @override
  State<HalamanProdukWidget> createState() => _HalamanProdukWidgetState();
}

class _HalamanProdukWidgetState extends State<HalamanProdukWidget> {
  final pakaianService = PakaianService();
  final _formKeyTambah = GlobalKey<FormState>();

  // List lokal untuk menampung data dari Supabase
  List<Map<String, dynamic>> listProdukSupabase = [];

  final TextEditingController brandBaruController = TextEditingController();
  final TextEditingController namaBaruController = TextEditingController();
  final TextEditingController hargaBaruController = TextEditingController();
  final TextEditingController gambarBaruController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProduk();
  }

  Future<void> loadProduk() async {
    try {
      final data = await pakaianService.getProduk();
      if (mounted) {
        setState(() {
          listProdukSupabase = data;
          // Sinkronisasi ke homeState agar data global terupdate
          widget.homeState.setState(() {
            widget.homeState.produkList = data;
          });
        });
      }
    } catch (e) {
      debugPrint("Error load produk: $e");
    }
  }

  // Fungsi untuk memproses penambahan produk ke database
  Future<void> prosesTambahProduk() async {
    if (_formKeyTambah.currentState!.validate()) {
      try {
        debugPrint("Mencoba menambah data ke Supabase...");

        await pakaianService.tambahProduk(
          brand: brandBaruController.text,
          produk: namaBaruController.text,
          harga: int.parse(hargaBaruController.text),
          gambar: gambarBaruController.text.isEmpty
              ? "https://via.placeholder.com/400"
              : gambarBaruController.text,
        );

        // Bersihkan form setelah berhasil
        brandBaruController.clear();
        namaBaruController.clear();
        hargaBaruController.clear();
        gambarBaruController.clear();

        await loadProduk(); // Refresh list
        if (mounted) Navigator.pop(context); // Tutup BottomSheet

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil ditambah!")),
        );
      } catch (e) {
        debugPrint("Gagal menambah produk: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e")),
        );
      }
    }
  }

  void tampilFormTambahProduk() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
          key: _formKeyTambah,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tambah Stok Baru",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                TextFormField(
                  controller: brandBaruController,
                  decoration: const InputDecoration(
                      labelText: "Brand", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Isi brand" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: namaBaruController,
                  decoration: const InputDecoration(
                      labelText: "Nama Produk", border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? "Isi nama produk" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: hargaBaruController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Harga", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Isi harga" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: gambarBaruController,
                  decoration: const InputDecoration(
                      labelText: "Link Gambar (URL)",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white),
                    onPressed: prosesTambahProduk,
                    child: const Text("Simpan ke Database"),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tampilDialogCheckout(Map<String, dynamic> produk) {
    jumlahController.text = "1";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Beli ${produk['nama'] ?? produk['produk']}"),
        content: TextField(
          controller: jumlahController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Jumlah"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            child: const Text("Checkout"),
            onPressed: () {
              int jumlah = int.tryParse(jumlahController.text) ?? 1;
              int harga = produk['harga'] ?? 0;

              widget.homeState.setState(() {
                widget.homeState.dataPenjualan.insert(0, {
                  "brand": produk['brand'],
                  "produk": produk['nama'] ?? produk['produk'],
                  "harga": harga,
                  "jumlah": jumlah,
                  "total": harga * jumlah,
                  "tanggal": DateTime.now().toString(),
                });
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKartuProduk(Map<String, dynamic> produk) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              produk['gambar'] ?? "https://via.placeholder.com/400",
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(produk['brand'] ?? "-",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(produk['nama'] ?? produk['produk'] ?? "-",
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  FormatRupiah.toRupiah(produk['harga'] ?? 0),
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon:
                        const Icon(Icons.add_shopping_cart, color: Colors.pink),
                    onPressed: () => tampilDialogCheckout(produk),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stok Produk Butik"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadProduk),
          IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: tampilFormTambahProduk),
        ],
      ),
      body: listProdukSupabase.isEmpty
          ? const Center(child: Text("Belum ada data di Supabase"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: listProdukSupabase.length,
              itemBuilder: (context, index) =>
                  _buildKartuProduk(listProdukSupabase[index]),
            ),
    );
  }
}
