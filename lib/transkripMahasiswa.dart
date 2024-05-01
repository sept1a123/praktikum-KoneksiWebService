import 'dart:convert'; // Import library dart:convert untuk menggunakan fungsi jsonDecode dan jsonEncode.

void main() {
  // Fungsi utama yang akan dieksekusi saat program dijalankan.
  String jsonTranskrip = '''
  {
    "nama": "Dwi Septiajayanti",
    "nim": "2082010042",
    "mata_kuliah": [
      {
        "kode": "MK01",
        "nama": "Pemrograman Dekstop",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode": "MK201",
        "nama": "Data Base",
        "sks": 4,
        "nilai": "B+"
      },
      {
        "kode": "MK301",
        "nama": "Pemrograman Web",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode": "MK401",
        "nama": "Rekayasa Perangkat Lunak",
        "sks": 4,
        "nilai": "A"
      }
    ]
  }
  ''';

  Map<String, dynamic> transkrip = jsonDecode(
      jsonTranskrip); // Mengonversi JSON string ke dalam bentuk objek Map.

  List<dynamic> mataKuliah = transkrip[
      'mata_kuliah']; // Mengakses daftar mata kuliah dari objek transkrip.

  double totalSks = 0; // Inisialisasi variabel untuk menyimpan total SKS.
  double totalBobot =
      0; // Inisialisasi variabel untuk menyimpan total bobot nilai.

  for (var mk in mataKuliah) {
    // Looping melalui setiap mata kuliah dalam daftar.
    totalSks += mk[
        'sks']; // Menambahkan jumlah SKS dari mata kuliah saat ini ke total SKS.
    totalBobot += _convertNilaiToBobot(mk['nilai']) *
        mk['sks']; // Menambahkan bobot nilai mata kuliah saat ini ke total bobot nilai.
  }

  double ipk =
      totalBobot / totalSks; // Menghitung Indeks Prestasi Kumulatif (IPK).

  print(
      'IPK ${transkrip['nama']}: ${ipk.toStringAsFixed(2)}'); // Mencetak IPK mahasiswa dengan dua angka di belakang koma.
}

double _convertNilaiToBobot(String nilai) {
  // Fungsi untuk mengonversi nilai huruf menjadi bobot numerik.
  switch (nilai) {
    // Memulai percabangan berdasarkan nilai huruf.
    case 'A': // Jika nilai huruf adalah A, mengembalikan bobot 4.0.
      return 4.0;
    case 'A-': // Jika nilai huruf adalah A-, mengembalikan bobot 3.75.
      return 3.75;
    case 'B+': // Jika nilai huruf adalah B+, mengembalikan bobot 3.5.
      return 3.5;
    case 'B': // Jika nilai huruf adalah B, mengembalikan bobot 3.0.
      return 3.0;
    case 'B-': // Jika nilai huruf adalah B-, mengembalikan bobot 2.75.
      return 2.75;
    case 'C+': // Jika nilai huruf adalah C+, mengembalikan bobot 2.5.
      return 2.5;
    case 'C': // Jika nilai huruf adalah C, mengembalikan bobot 2.0.
      return 2.0;
    case 'D': // Jika nilai huruf adalah D, mengembalikan bobot 1.0.
      return 1.0;
    default: // Untuk nilai lainnya, mengembalikan bobot 0.0.
      return 0.0;
  }
}
