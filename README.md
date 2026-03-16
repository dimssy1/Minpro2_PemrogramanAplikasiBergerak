# Minpro2_PemrogramanAplikasiBergerak

# Butik Stylish App 👗

Aplikasi manajemen stok dan penjualan butik sederhana yang dibangun menggunakan **Flutter** dan **Supabase** sebagai database cloud-nya.

## Deskripsi Aplikasi
Butik Stylish adalah aplikasi untuk membantu pemilik butik dalam mencatat stok pakaian secara real-time. Aplikasi ini memungkinkan pengguna untuk melihat daftar produk, menambahkan produk baru ke database cloud, dan melakukan simulasi perhitungan penjualan (checkout).

## Fitur Aplikasi
* **Real-time Product List**: Menampilkan daftar produk langsung dari database Supabase.
* **Add New Product**: Menambahkan data produk (Brand, Nama, Harga, Gambar) ke cloud.
* **Shopping Cart System**: Simulasi pembelian dengan input jumlah barang dan perhitungan total otomatis.
* **Sales Tracking**: Mencatat riwayat penjualan selama aplikasi berjalan.
* **Format Rupiah**: Konversi harga otomatis ke format mata uang Indonesia.

## Widget yang Digunakan
* **StatefulWidget & StatelessWidget**: Untuk manajemen state halaman.
* **GridView.builder**: Menampilkan daftar produk dalam bentuk grid 2 kolom.
* **FutureBuilder / Async-Await**: Mengambil data secara asynchronous dari API Supabase.
* **ModalBottomSheet**: Form input modern yang muncul dari bawah layar.
* **TextFormField with Validation**: Form input dengan validasi agar data tidak kosong.
* **Card & ClipRantiAlias**: Membuat tampilan produk yang rapi dengan sudut melengkung.
* **Navigation Bar**: Navigasi antar halaman (Produk & Penjualan).
