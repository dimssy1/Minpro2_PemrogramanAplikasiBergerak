class PakaianModel {
  final String brand;
  final String produk;
  final int harga;
  final int jumlah;
  final int total;
  final String imageUrl;

  PakaianModel({
    required this.brand,
    required this.produk,
    required this.harga,
    required this.jumlah,
    required this.total,
    required this.imageUrl,
  });

  // Convert Map (dari JSON/database) ke Object Model
  factory PakaianModel.fromMap(Map<String, dynamic> map) {
    return PakaianModel(
      brand: map['brand'] ?? '',
      produk: map['produk'] ?? '',
      harga: map['harga'] ?? 0,
      jumlah: map['jumlah'] ?? 0,
      total: map['total'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Convert Object Model ke Map (untuk disimpan)
  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'produk': produk,
      'harga': harga,
      'jumlah': jumlah,
      'total': total,
      'imageUrl': imageUrl,
    };
  }
}
