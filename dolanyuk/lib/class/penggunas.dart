// ignore_for_file: non_constant_identifier_names

class Penggunas {
  int id;
  String email;
  String nama_lengkap;
  String? gambar;
  String password;

  Penggunas(
      {required this.id,
      required this.email,
      required this.nama_lengkap,
      this.gambar,
      required this.password});

  factory Penggunas.fromJson(Map<String, dynamic> json) {
    return Penggunas(
      id: json['id'] as int,
      email: json['email'] as String,
      nama_lengkap: json['nama_lengkap'] as String,
      gambar: json['gambar'],
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lengkap': nama_lengkap,
      'email': email,
      'gambar': gambar,
      'password': password,
    };
  }
}
