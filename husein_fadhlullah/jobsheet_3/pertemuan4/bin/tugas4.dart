import 'dart:io';

void main() {
  // 1. Program untuk menyimpan daftar nama mahasiswa menggunakan Growable List
  List<String> mahasiswa = [];
  mahasiswa.addAll(["Adit", "Budi", "Eka", "Odri"]);
  print("Daftar Mahasiswa: $mahasiswa");
  print("Jumlah mahasiswa: ${mahasiswa.length}\n");

  // 2. Program untuk menghitung union & intersection dari dua set
  print("Masukkan elemen Set A (pisahkan dengan spasi): ");
  Set<String> setA = stdin.readLineSync()!.split(" ").toSet();
  print("Masukkan elemen Set B (pisahkan dengan spasi): ");
  Set<String> setB = stdin.readLineSync()!.split(" ").toSet();
  Set<String> unionSet = setA.union(setB);
  Set<String> intersectionSet = setA.intersection(setB);

  print("Set A: $setA");
  print("Set B: $setB");
  print("Union: $unionSet");
  print("Intersection: $intersectionSet\n");

  // 3. Gunakan Map untuk menyimpan data barang
  Map<String, Map<String, dynamic>> barang = {
    "B001": {"nama": "Laptop", "harga": 7500000},
    "B002": {"nama": "Mouse", "harga": 150000},
    "B003": {"nama": "Keyboard", "harga": 300000},
  };

  print("Data Barang:");
  barang.forEach((kode, data) {
    print("Kode: $kode, Nama: ${data['nama']}, Harga: ${data['harga']}");
  });
  print("");

  // 4. Gunakan Record untuk menyimpan data mahasiswa (nim, nama, ipk)
  var mahasiswaRecord = (nim: "123456", nama: "Adit", ipk: 3.75);
  print("Data Mahasiswa (Record): nim=${mahasiswaRecord.nim}, "
      "nama=${mahasiswaRecord.nama}, ipk=${mahasiswaRecord.ipk}\n");

  // 5. Closure untuk menghitung diskon bertingkat
  var hitungDiskon = buatDiskon();
  print("Panggilan 1, diskon: ${hitungDiskon()}%");
  print("Panggilan 2, diskon: ${hitungDiskon()}%");
  print("Panggilan 3, diskon: ${hitungDiskon()}%");
  print("Panggilan 4, diskon: ${hitungDiskon()}%");
}

// Function closure diskon bertingkat
Function buatDiskon() {
  int diskon = 0;
  return () {
    diskon += 5;
    return diskon;
  };
}
