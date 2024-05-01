import 'package:flutter/material.dart'; // Import package flutter material untuk membangun antarmuka pengguna.
import 'package:http/http.dart'
    as http; // Import package http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Import package dart:convert untuk mengonversi data JSON.

void main() {
  // Fungsi utama yang akan dijalankan saat aplikasi dimulai.
  runApp(MyApp()); // Menjalankan aplikasi Flutter.
}

class Activity {
  // Kelas Activity untuk merepresentasikan aktivitas.
  final String aktivitas; // Variabel untuk menyimpan deskripsi aktivitas.
  final String jenis; // Variabel untuk menyimpan jenis aktivitas.

  Activity(
      {required this.aktivitas,
      required this.jenis}); // Konstruktor kelas Activity.

  factory Activity.fromJson(Map<String, dynamic> json) {
    // Konstruktor factory untuk membuat objek Activity dari JSON.
    return Activity(
      // Mengembalikan objek Activity dengan data dari JSON.
      aktivitas: json['activity'], // Mendapatkan deskripsi aktivitas dari JSON.
      jenis: json['type'], // Mendapatkan jenis aktivitas dari JSON.
    );
  }
}

class MyApp extends StatelessWidget {
  // Kelas MyApp untuk membuat aplikasi Flutter.
  @override
  Widget build(BuildContext context) {
    // Metode build untuk membangun antarmuka pengguna.
    return MaterialApp(
      // Mengembalikan MaterialApp sebagai root widget aplikasi.
      title: 'Rekomendasi Aktivitas', // Judul aplikasi.
      theme: ThemeData(
        // Tema aplikasi.
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Pengaturan kepadatan visual.
      ),
      home: HalamanAktivitas(), // Halaman utama aplikasi.
    );
  }
}

class HalamanAktivitas extends StatefulWidget {
  // Kelas HalamanAktivitas untuk menampilkan aktivitas.
  @override
  _HalamanAktivitasState createState() =>
      _HalamanAktivitasState(); // Metode untuk membuat state HalamanAktivitas.
}

class _HalamanAktivitasState extends State<HalamanAktivitas> {
  // Kelas _HalamanAktivitasState sebagai state dari HalamanAktivitas.
  late Future<Activity>
      futureActivity; // Variabel untuk menyimpan aktivitas yang akan datang.
  String url =
      "https://www.boredapi.com/api/activity"; // URL endpoint untuk mendapatkan aktivitas.

  @override
  void initState() {
    // Metode untuk inisialisasi state.
    super.initState(); // Memanggil metode initState dari superclass.
    futureActivity =
        fetchData(); // Memuat aktivitas pertama kali aplikasi dimulai.
  }

  Future<Activity> fetchData() async {
    // Metode untuk mengambil data aktivitas dari API.
    final response = await http.get(Uri.parse(
        url)); // Mengirim permintaan HTTP untuk mendapatkan data aktivitas.
    if (response.statusCode == 200) {
      // Jika permintaan berhasil.
      return Activity.fromJson(jsonDecode(
          response.body)); // Mengembalikan objek Activity dari data JSON.
    } else {
      // Jika terjadi kesalahan dalam permintaan.
      throw Exception(
          'Gagal memuat aktivitas'); // Membuang exception dengan pesan kesalahan.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun antarmuka pengguna.
    return Scaffold(
      // Mengembalikan Scaffold sebagai struktur dasar aplikasi.
      appBar: AppBar(
        // AppBar sebagai bagian atas layar.
        title: Text('Rekomendasi Aktivitas'), // Judul AppBar.
      ),
      body: Center(
        // Widget body yang akan berada di tengah layar.
        child: Column(
          // Widget untuk menata child dalam kolom vertikal.
          mainAxisAlignment: MainAxisAlignment
              .center, // Menyusun child secara vertikal di tengah.
          children: <Widget>[
            // Daftar widget dalam kolom.
            ElevatedButton(
              // Tombol untuk memuat aktivitas baru.
              onPressed: () {
                // Aksi ketika tombol ditekan.
                setState(() {
                  // Memanggil setState untuk memperbarui UI.
                  futureActivity = fetchData(); // Memuat aktivitas baru.
                });
              },
              child: Text(
                // Teks pada tombol.
                "Saya bosan ...", // Pesan pada tombol.
                style: TextStyle(color: Colors.white), // Gaya teks pada tombol.
              ),
              style: ButtonStyle(
                // Gaya tombol.
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(
                        255, 173, 173, 173)), // Warna latar belakang tombol.
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15)), // Padding tombol.
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10))), // Bentuk tombol.
              ),
            ),
            SizedBox(height: 20), // Jarak antara tombol dan FutureBuilder.
            FutureBuilder<Activity>(
              // Widget untuk menampilkan aktivitas yang direkomendasikan.
              future: futureActivity, // Future yang akan ditampilkan.
              builder: (context, snapshot) {
                // Metode builder untuk mengatur tampilan FutureBuilder.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Jika sedang memuat data.
                  return CircularProgressIndicator(
                    // Tampilan indikator loading.
                    color: const Color.fromARGB(
                        255, 173, 173, 173), // Warna indikator loading.
                  );
                } else if (snapshot.hasError) {
                  // Jika terjadi kesalahan.
                  return Text(
                    // Teks untuk menampilkan pesan kesalahan.
                    'Error: ${snapshot.error}', // Pesan kesalahan.
                    style: TextStyle(
                        color: Colors.red), // Gaya teks untuk pesan kesalahan.
                  );
                } else if (snapshot.hasData) {
                  // Jika data berhasil dimuat.
                  return Column(
                    // Menampilkan aktivitas yang direkomendasikan.
                    children: [
                      Text(
                        // Teks untuk judul aktivitas.
                        'Aktivitas yang direkomendasikan:', // Judul teks.
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black), // Gaya teks untuk judul.
                      ),
                      SizedBox(
                          height:
                              10), // Jarak antara judul dan deskripsi aktivitas.
                      Text(
                        // Teks untuk deskripsi aktivitas.
                        '${snapshot.data!.aktivitas}', // Deskripsi aktivitas yang direkomendasikan.
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .blue), // Gaya teks untuk deskripsi aktivitas.
                        textAlign: TextAlign.center, // Penataan teks ke tengah.
                      ),
                      SizedBox(
                          height:
                              10), // Jarak antara deskripsi aktivitas dan jenis aktivitas.
                      Text(
                        // Teks untuk jenis aktivitas.
                        'Jenis: ${snapshot.data!.jenis}', // Jenis aktivitas yang direkomendasikan.
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors
                                .black), // Gaya teks untuk jenis aktivitas.
                      ),
                    ],
                  );
                } else {
                  // Jika tidak ada data yang dimuat.
                  return SizedBox(); // Widget kosong.
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
