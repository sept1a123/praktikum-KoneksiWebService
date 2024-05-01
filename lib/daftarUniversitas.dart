import 'package:flutter/material.dart'; // Import library flutter material untuk membuat antarmuka pengguna.
import 'package:http/http.dart'
    as http; // Import library http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Import library dart:convert untuk mengonversi data JSON.

void main() {
  // Fungsi utama yang akan dijalankan saat aplikasi dimulai.
  runApp(MyApp()); // Menjalankan aplikasi Flutter.
}

class University {
  // Kelas University untuk merepresentasikan universitas.
  final String name; // Variabel untuk menyimpan nama universitas.
  final String website; // Variabel untuk menyimpan situs web universitas.

  University(
      {required this.name,
      required this.website}); // Konstruktor kelas University.

  factory University.fromJson(Map<String, dynamic> json) {
    // Konstruktor factory untuk membuat objek University dari JSON.
    return University(
      // Mengembalikan objek University dengan data dari JSON.
      name: json['name'], // Mendapatkan nama universitas dari JSON.
      website: json['web_pages']
          [0], // Mendapatkan situs web universitas dari JSON.
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
      title: 'Daftar Universitas Indonesia', // Judul aplikasi.
      theme: ThemeData(
        // Tema aplikasi.
        scaffoldBackgroundColor:
            Colors.grey[200], // Warna latar belakang scaffold.
        textTheme: TextTheme(
          // Tema teks aplikasi.
          headline6: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins'), // Gaya teks untuk judul.
          subtitle1: TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins'), // Gaya teks untuk teks tambahan.
        ),
      ),
      home: UniversityList(), // Halaman utama aplikasi.
    );
  }
}

class UniversityList extends StatefulWidget {
  // Kelas UniversityList untuk menampilkan daftar universitas.
  @override
  _UniversityListState createState() =>
      _UniversityListState(); // Metode untuk membuat state UniversityList.
}

class _UniversityListState extends State<UniversityList> {
  // Kelas _UniversityListState sebagai state dari UniversityList.
  late Future<List<University>>
      futureUniversity; // Variabel untuk menyimpan universitas yang akan datang.
  int selectedIndex =
      -1; // Indeks universitas yang dipilih, awalnya tidak ada yang dipilih.

  @override
  void initState() {
    // Metode untuk inisialisasi state.
    super.initState(); // Memanggil metode initState dari superclass.
    futureUniversity =
        fetchUniversity(); // Memuat daftar universitas saat aplikasi dimulai.
  }

  Future<List<University>> fetchUniversity() async {
    // Metode untuk mengambil data universitas dari API.
    final response = await http.get(
        // Mengirim permintaan HTTP untuk mendapatkan data universitas.
        Uri.parse("http://universities.hipolabs.com/search?country=Indonesia"));

    if (response.statusCode == 200) {
      // Jika permintaan berhasil.
      List<University> universities =
          []; // Variabel untuk menyimpan daftar universitas.
      List<dynamic> jsonData =
          jsonDecode(response.body); // Mendekode data JSON dari respons.
      jsonData.forEach((university) {
        // Iterasi melalui setiap universitas dalam data JSON.
        universities.add(University.fromJson(
            university)); // Menambahkan universitas ke dalam daftar.
      });
      return universities; // Mengembalikan daftar universitas.
    } else {
      // Jika terjadi kesalahan dalam permintaan.
      throw Exception(
          'Gagal memuat data'); // Membuang exception dengan pesan kesalahan.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun antarmuka pengguna.
    return Scaffold(
      // Mengembalikan Scaffold sebagai struktur dasar aplikasi.
      appBar: AppBar(
        // AppBar sebagai bagian atas layar.
        title: Row(
          // Baris untuk menampilkan judul.
          children: [
            Icon(Icons.school, color: Colors.white), // Ikon sekolah.
            SizedBox(width: 8), // Jarak antara ikon dan teks.
            Text(
              // Teks judul.
              'Daftar Universitas Indonesia', // Judul teks.
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins'), // Gaya teks untuk judul.
            ),
          ],
        ),
        flexibleSpace: Container(
          // Ruang fleksibel untuk tata letak aplikasi.
          decoration: BoxDecoration(
            // Dekorasi untuk flexibleSpace.
            gradient: LinearGradient(
              // Gradien untuk latar belakang.
              colors: [Colors.lightBlue, Colors.grey[300]!], // Warna gradien.
              begin: Alignment.centerLeft, // Posisi awal gradien.
              end: Alignment.centerRight, // Posisi akhir gradien.
            ),
          ),
        ),
      ),
      body: Center(
        // Widget body yang akan berada di tengah layar.
        child: FutureBuilder<List<University>>(
          // Widget untuk menampilkan daftar universitas.
          future: futureUniversity, // Future yang akan ditampilkan.
          builder: (context, snapshot) {
            // Metode builder untuk mengatur tampilan FutureBuilder.
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Jika sedang memuat data.
              return CircularProgressIndicator(
                // Tampilan indikator loading.
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.lightBlue), // Warna indikator loading.
              );
            } else if (snapshot.hasError) {
              // Jika terjadi kesalahan.
              return Text(
                // Teks untuk menampilkan pesan kesalahan.
                'Error: ${snapshot.error}', // Pesan kesalahan.
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins'), // Gaya teks untuk pesan kesalahan.
              );
            } else if (snapshot.hasData) {
              // Jika data berhasil dimuat.
              return ListView.builder(
                // ListView untuk menampilkan daftar universitas.
                itemCount: snapshot.data!.length, // Jumlah item dalam daftar.
                itemBuilder: (context, index) {
                  // Metode itemBuilder untuk membuat item daftar.
                  return InkWell(
                    // InkWell untuk menangani interaksi ketika item daftar ditekan.
                    onTap: () {
                      // Aksi ketika item daftar ditekan.
                      showDialog(
                        // Menampilkan dialog dengan detail universitas.
                        context: context, // Konteks aplikasi.
                        builder: (BuildContext context) {
                          // Metode builder untuk membuat dialog.
                          return AlertDialog(
                            // AlertDialog untuk menampilkan detail universitas.
                            title: Text('Detail Universitas'), // Judul dialog.
                            content: Text(
                                'Nama: ${snapshot.data![index].name}'), // Isi dialog.
                            actions: [
                              // Aksi yang tersedia di dialog.
                              TextButton(
                                // Tombol untuk menutup dialog.
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Menutup dialog.
                                },
                                child: Text('Tutup'), // Teks tombol.
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onHover: (value) {
                      // Aksi ketika item daftar diberi hover.
                      setState(() {
                        // Memanggil setState untuk memperbarui UI.
                        selectedIndex = value
                            ? index
                            : -1; // Mengatur selectedIndex berdasarkan hover.
                      });
                    },
                    child: AnimatedContainer(
                      // AnimatedContainer untuk animasi item daftar.
                      duration: Duration(milliseconds: 200), // Durasi animasi.
                      margin: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16), // Margin item daftar.
                      decoration: BoxDecoration(
                        // Dekorasi item daftar.
                        gradient: LinearGradient(
                          // Gradien untuk latar belakang.
                          colors: [
                            Colors.lightBlue.withOpacity(selectedIndex == index
                                ? 0.8
                                : 1.0), // Warna gradien atas.
                            Colors.grey[300]!.withOpacity(selectedIndex == index
                                ? 0.8
                                : 1.0), // Warna gradien bawah.
                          ],
                          begin: Alignment.centerLeft, // Posisi awal gradien.
                          end: Alignment.centerRight, // Posisi akhir gradien.
                        ),
                        borderRadius: BorderRadius.circular(
                            16), // Mengatur border radius item daftar.
                        boxShadow: [
                          // Efek bayangan item daftar.
                          BoxShadow(
                            // Bayangan untuk item daftar.
                            color: Colors.black.withOpacity(
                                selectedIndex == index
                                    ? 0.4
                                    : 0.2), // Warna bayangan.
                            spreadRadius: selectedIndex == index
                                ? 4
                                : 2, // Penyebaran bayangan.
                            blurRadius: selectedIndex == index
                                ? 8
                                : 4, // Radius blur bayangan.
                            offset: Offset(0, 2), // Posisi bayangan.
                          ),
                        ],
                      ),
                      child: ListTile(
                        // ListTile untuk menampilkan konten item daftar.
                        leading: Icon(Icons.school,
                            color: Colors.white), // Ikon sekolah.
                        title: Text(
                          // Teks untuk judul item daftar.
                          snapshot.data![index].name, // Nama universitas.
                          style: TextStyle(
                            // Gaya teks untuk judul.
                            color: Colors.white, // Warna teks judul.
                            fontWeight:
                                FontWeight.bold, // Ketebalan teks judul.
                            fontFamily: 'Poppins', // Jenis font teks judul.
                          ),
                        ),
                        subtitle: Text(
                          // Teks untuk subjudul item daftar.
                          snapshot
                              .data![index].website, // Situs web universitas.
                          style: TextStyle(
                            // Gaya teks untuk subjudul.
                            color: Colors.white, // Warna teks subjudul.
                            fontFamily: 'Poppins', // Jenis font teks subjudul.
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              // Jika tidak ada data yang dimuat.
              return Text(
                // Teks untuk menampilkan pesan bahwa tidak ada data.
                'Tidak ada data', // Pesan bahwa tidak ada data.
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins'), // Gaya teks untuk pesan.
              );
            }
          },
        ),
      ),
    );
  }
}
