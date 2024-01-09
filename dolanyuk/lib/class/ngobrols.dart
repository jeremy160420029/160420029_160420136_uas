// ignore_for_file: non_constant_identifier_names, unnecessary_cast

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
      id: json['ngobrol_id'] as int,
      isi: json['isi'] as String,
      list_jadwals: ListJadwals.fromJson(json['list_jadwals']) as ListJadwals
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
