// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable, avoid_print, annotate_overrides, camel_case_types, avoid_init_to_null, unnecessary_new, unnecessary_null_comparison, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';

import 'package:dolanyuk/class/jadwals.dart';
import 'package:dolanyuk/screen/ruangan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../class/penggunas.dart';
import '../main.dart';

class Cari extends StatefulWidget {
  const Cari({Key? key}) : super(key: key);

  @override
  State<Cari> createState() => _CariState();
}

Penggunas? pengguna_aktif = null;

class _CariState extends State<Cari> {
  String _temp = 'waiting API respond…';
  String _txtCari = '';
  List<Jadwals> jadwals = [];

  Future<String> cekPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
    return json_pengguna_aktif;
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420136/dolanyuk/cari_jadwal.php"),
        body: {'cari': _txtCari, 'pengguna_id': pengguna_aktif!.id.toString()});

    if (response.statusCode == 200) {
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

  void join(penggunaID, jadwalID) async {
    final response = await http.post(
      Uri.parse('https://ubaya.me/flutter/160420136/dolanyuk/join.php'),
      body: {'pengguna': penggunaID, 'jadwal': jadwalID},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Sukses Join',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Selamat, kamu berhasil join pada jadwal dolanan. Kamu bisa ngobrol bareng teman-teman dolananmu. Temanmu menghargai komitmemu untuk hadir dan bermain bersama!',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          bacaData();
                        });
                      },
                      child: const Text('OK'),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.purple[200]),
                        foregroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.black),
                      ),
                    ),
                  ],
                ));
      } else if (json['result'] == 'fail') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json['message']),
        ));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget DaftarJadwal() {
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Ruangan(
                                          jadwalID: jadwals[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.group),
                                  label: Text(
                                      jadwals[index].current_member.toString() +
                                          '/' +
                                          jadwals[index]
                                              .object_dolanan
                                              .minimal_member
                                              .toString() +
                                          ' orang'),
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
                                    icon: Icon(Icons.login),
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
                                    label: Text('Join'),
                                    onPressed: () {
                                      //todo: tolong pindahin fungsi join kesini
                                      join(pengguna_aktif?.id.toString(),
                                          jadwals[index].id.toString());
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.search),
            labelText: 'Judul mengandung kata:',
          ),
          onFieldSubmitted: (value) {
            setState(() {
              _txtCari = value;
            });
            bacaData();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Container(
        margin: EdgeInsets.all(20),
        child: DaftarJadwal(),
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

  @override
  void initState() {
    super.initState();
    cekPengguna().then((String result) {
      pengguna_aktif = Penggunas.fromJson(jsonDecode(result));
      bacaData();
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: Cari(),
  ));
}
