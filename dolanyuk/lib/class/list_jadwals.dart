// ignore_for_file: non_constant_identifier_names

import 'package:dolanyuk/class/dolanans.dart';
import 'package:dolanyuk/class/jadwals.dart';
import 'package:dolanyuk/class/penggunas.dart';

List<ListJadwals> LJs = [];

class ListJadwals {
  int list_jadwal_id;
  Penggunas object_pengguna;
  Jadwals object_jadwal;

  ListJadwals({
    required this.list_jadwal_id,
    required this.object_pengguna,
    required this.object_jadwal,
  });

  factory ListJadwals.fromJson(Map<String, dynamic> json) {
    return ListJadwals(
      list_jadwal_id: json['list_jadwal_id'] as int,
      object_pengguna: json['object_pengguna'] != null
          ? Penggunas.fromJson(json['object_pengguna']) as Penggunas
          : Penggunas(
              id: 0, email: '', nama_lengkap: '', gambar: '', password: ''),
      object_jadwal: json['object_jadwal'] != null
          ? Jadwals.fromJson(json['object_jadwal']) as Jadwals
          : Jadwals(
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
                  gambar_dolanan: '')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_jadwal_id': list_jadwal_id,
      'object_pengguna': object_pengguna.toJson(),
      'object_jadwal': object_jadwal.toJson(),
    };
  }
}
