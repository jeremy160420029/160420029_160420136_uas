// ignore_for_file: non_constant_identifier_names

class Pengguna {
  int id;
  String email;
  String nama_lengkap;
  String? gambar;

  Pengguna({required this.id, required this.email, required this.nama_lengkap, this.gambar});
  
  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'] as int,
      email: json['email'] as String,
      nama_lengkap: json['nama_lengkap'] as String,
      gambar: json['gambar'],
    );
  }
}