// ignore_for_file: non_constant_identifier_names, unnecessary_cast

import 'dolanans.dart';

class Jadwals {
  int id;
  String tanggal;
  String jam;
  String lokasi;
  String alamat;
  int current_member;
  Dolanans object_dolanan;

  Jadwals(
      {required this.id,
      required this.tanggal,
      required this.jam,
      required this.lokasi,
      required this.alamat,
      required this.current_member,
      required this.object_dolanan});

  factory Jadwals.fromJson(Map<String, dynamic> json) {
    return Jadwals(
      id: json['jadwal'] as int? ?? 0,
      tanggal: json['tanggal'] as String? ?? '',
      jam: json['jam'] as String? ?? '',
      lokasi: json['lokasi'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      current_member: json['current_member'] as int? ?? 0,
      object_dolanan: json['object_dolanan'] != null
          ? Dolanans.fromJson(json['object_dolanan']) as Dolanans
          : Dolanans(
              id: 0, nama_dolan: '', minimal_member: 0, gambar_dolanan: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jadwal': id,
      'tanggal': tanggal,
      'jam': jam,
      'lokasi': lokasi,
      'alamat': alamat,
      'current_member': current_member,
      'object_dolanan': object_dolanan.toJson(),
    };
  }
}
