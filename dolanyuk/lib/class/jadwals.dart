// ignore_for_file: non_constant_identifier_names

List<Jadwals> Js = [];

class Jadwals {
  int id;
  DateTime tanggal;
  DateTime jam;
  String lokasi;
  String alamat;
  int dolan_id;

  Jadwals(
      {required this.id,
      required this.tanggal,
      required this.jam,
      required this.lokasi,
      required this.alamat,
      required this.dolan_id});

  factory Jadwals.fromJson(Map<String, dynamic> json) {
    return Jadwals(
      id: json['id'] as int,
      tanggal: json['tanggal'] as DateTime,
      jam: json['jam'] as DateTime,
      lokasi: json['lokasi'] as String,
      alamat: json['alamat'] as String,
      dolan_id: json['dolan_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'jam': jam,
      'lokasi': lokasi,
      'alamat': alamat,
      'dolan_id': dolan_id,
    };
  }
}
