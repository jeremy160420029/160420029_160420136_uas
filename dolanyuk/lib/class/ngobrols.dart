// ignore_for_file: non_constant_identifier_names

import 'package:dolanyuk/class/dolanans.dart';
import 'package:dolanyuk/class/jadwals.dart';
import 'package:dolanyuk/class/list_jadwals.dart';
import 'package:dolanyuk/class/penggunas.dart';

class Ngobrols {
  int id;
  String isi;
  ListJadwals list_jadwals;

  Ngobrols({
    required this.id,
    required this.isi,
    required this.list_jadwals,
  });

  factory Ngobrols.fromJson(Map<String, dynamic> json) {
    return Ngobrols(
      id: json['id'] as int? ?? 0,
      isi: json['isi'] as String? ?? '',
      list_jadwals: json['list_jadwalss'] != null
          ? ListJadwals.fromJson(json['list_jadwalss']) as ListJadwals
          : ListJadwals(
              list_jadwal_id: json['list_jadwal_id'] as int,
              object_pengguna: Penggunas(
                  id: 0, email: '', nama_lengkap: '', gambar: '', password: ''),
              object_jadwal: Jadwals(
                  id: 0,
                  tanggal: '',
                  jam: '',
                  lokasi: '',
                  alamat: '',
                  current_member: 0,
                  object_dolanan: Dolanans(
                      id: 0,
                      nama_dolan: '',
                      minimal_member: 0,
                      gambar_dolanan: ''))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isi': isi,
      'list_jadwals': list_jadwals,
    };
  }
}
