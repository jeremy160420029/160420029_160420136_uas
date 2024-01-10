// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable, avoid_print, annotate_overrides, camel_case_types, avoid_init_to_null, unnecessary_new, unnecessary_null_comparison, sized_box_for_whitespace

import 'dart:convert';
import 'package:dolanyuk/class/jadwals.dart';
import 'package:dolanyuk/screen/ngobrol.dart';
import 'package:dolanyuk/screen/ruangan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../class/penggunas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Jadwal extends StatefulWidget {
  const Jadwal({super.key});

  @override
  State<Jadwal> createState() => _JadwalState();
}

Penggunas? pengguna_aktif = null;

class _JadwalState extends State<Jadwal> {
  List<Jadwals> jadwals = [];

  Future<String> cekPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
    return json_pengguna_aktif;
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420136/dolanyuk/jadwal_pengguna_list.php"),
        body: {'pengguna_id': pengguna_aktif!.id.toString()});
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    jadwals.clear();
    fetchData().then((value) {
      setState(() {
        Map json = jsonDecode(value);
        for (var _ in json['data']) {
          Jadwals jadwal = Jadwals.fromJson(_);
          jadwals.add(jadwal);
        }
      });
    });
  }

  Widget DaftarJadwalPengguna() {
    if (jadwals.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: jadwals.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Container(
                child: Card(
                    margin: EdgeInsets.only(top: 20),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AspectRatio(
                            //gambar dolanan
                            aspectRatio: 487 / 150,
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        alignment: FractionalOffset.topCenter,
                                        image: NetworkImage(jadwals[index]
                                            .object_dolanan
                                            .gambar_dolanan))))),
                        ListTile(
                          title: Text(jadwals[index].object_dolanan.nama_dolan,
                              style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500)), //nama dolanan
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child:
                                        Text(jadwals[index].tanggal)), //tanggal
                                Container(
                                    child: Text(jadwals[index].jam)), //jam
                                Container(
                                    child: ElevatedButton.icon(
                                      onPressed: (){
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Ruangan(
                                              jadwalID: jadwals[index].id,),
                                        ),
                                      );
                                      }, 
                                      icon: Icon(Icons.group), 
                                      label: Text(jadwals[index].current_member.toString() +'/' +jadwals[index].object_dolanan.minimal_member.toString() +' orang'), 
                                  )),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text(jadwals[index].lokasi), //lokasi
                                ),
                                Container(
                                    child:
                                        Text(jadwals[index].alamat)), //alamat
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  alignment: Alignment.topRight,
                                  child: ElevatedButton.icon(
                                    icon:
                                        Icon(Icons.chat_bubble_outline_rounded),
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Size(120, 40)),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.purple),
                                      foregroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.white),
                                    ),
                                    label: Text('Party Chat'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Ngobrol(
                                              jadwalID: jadwals[index].id, penggunaID: pengguna_aktif!.id,),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ]),
                        ),
                      ],
                    )));
          });
    } else {
      return Container(
          padding: EdgeInsets.only(top: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Jadwal main masih kosong ni'),
              Text('Cari konco main atau bikin jadwal baru aja')
            ],
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    cekPengguna().then((String result) {
      pengguna_aktif = Penggunas.fromJson(jsonDecode(result));
      bacaData();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
              child: Container(
        margin: EdgeInsets.all(20),
        child: DaftarJadwalPengguna(),
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'buat');
        },
        tooltip: 'Buat Jadwal',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
