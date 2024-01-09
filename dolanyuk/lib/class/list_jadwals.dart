// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable, avoid_print, annotate_overrides, camel_case_types, avoid_init_to_null, unnecessary_cast

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
      list_jadwal_id: json['id']?? 0 as int,
      object_pengguna: Penggunas.fromJson(json['object_pengguna']) as Penggunas,
      object_jadwal: Jadwals.fromJson(json['object_jadwal']) as Jadwals
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
