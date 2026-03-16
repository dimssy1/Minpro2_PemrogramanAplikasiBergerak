import 'package:supabase_flutter/supabase_flutter.dart';

class PakaianService {
  final supabase = Supabase.instance.client;

  // Tambahkan ini di dalam class PakaianService
  Future<List<Map<String, dynamic>>> getPenjualan() async {
    final response =
        await supabase.from('penjualan').select().order('id', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future tambahPenjualan(Map<String, dynamic> data) async {
    await supabase.from('penjualan').insert(data);
  }

  Future hapusPenjualan(int id) async {
    await supabase.from('penjualan').delete().eq('id', id);
  }

  Future updatePenjualan(int id, Map<String, dynamic> data) async {
    await supabase.from('penjualan').update(data).eq('id', id);
  }

  // READ: Mengambil data
  Future<List<Map<String, dynamic>>> getProduk() async {
    final response =
        await supabase.from('pakaian').select().order('id', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // CREATE: Tambah data
  Future tambahProduk({
    required String brand,
    required String produk,
    required int harga,
    required String gambar,
  }) async {
    await supabase.from('pakaian').insert({
      'brand': brand,
      'nama': produk, // sesuaikan dengan nama kolom di tabel supabase kamu
      'harga': harga,
      'gambar': gambar,
    });
  }

  // DELETE: Hapus data (Opsional tapi berguna)
  Future hapusProduk(int id) async {
    await supabase.from('pakaian').delete().eq('id', id);
  }
}
