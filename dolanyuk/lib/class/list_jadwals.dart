// ignore_for_file: non_constant_identifier_names
List<ListJadwals> LJs = [];

class ListJadwals {
  int idj;
  int idp;
  String email;
  String nama_lengkap;
  String? gambar;
  String password;

  ListJadwals({
    required this.idj,
    required this.idp,
    required this.email,
    required this.nama_lengkap,
    this.gambar,
    required this.password,
  });

  factory ListJadwals.fromJson(Map<String, dynamic> json) {
    return ListJadwals(
      idj: json['id'] as int,
      idp: json['id'] as int,
      email: json['email'] as String,
      nama_lengkap: json['nama_lengkap'] as String,
      gambar: json['gambar'],
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idj': idj,
      'idp': idp,
      'nama_lengkap': nama_lengkap,
      'email': email,
      'gambar': gambar,
      'password': password,
    };
  }
}
