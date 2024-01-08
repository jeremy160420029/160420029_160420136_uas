// ignore_for_file: non_constant_identifier_names

class Dolanans {
  int id;
  String nama_dolan;
  int minimal_member;
  String gambar_dolanan;

  Dolanans(
      {required this.id,
      required this.nama_dolan,
      required this.minimal_member,
      required this. gambar_dolanan});

  factory Dolanans.fromJson(Map<String, dynamic> json) {
    return Dolanans(
      id: json['id'] as int,
      nama_dolan: json['nama_dolan'] as String,
      minimal_member: json['minimal_member'] as int,
      gambar_dolanan: json['gambar_dolanan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_dolan': nama_dolan,
      'minimal_member': minimal_member,
      'gambar_dolanan': gambar_dolanan,
    };
  }
}
