class FormatRupiah {
  /// Mengubah angka menjadi format Rupiah
  /// Contoh: 50000 -> "Rp 50.000"
  static String toRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }
}
