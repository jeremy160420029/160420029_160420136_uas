// ignore_for_file: prefer_const_constructors, unused_field, depend_on_referenced_packages, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:dolanyuk/class/jadwals.dart';
import 'package:dolanyuk/screen/ruangan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cari extends StatefulWidget {
  const Cari({Key? key}) : super(key: key);

  @override
  State<Cari> createState() => _CariState();
}

class _CariState extends State<Cari> {
  String _temp = 'waiting API respond…';
  String _txtCari = '';
  List<Jadwals> Js = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420136/dolanyuk/cari_jadwal.php"),
        body: {'cari': _txtCari});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Js.clear();
    fetchData().then((value) {
      setState(() {
        Map json = jsonDecode(value);
        for (var _ in json['data']) {
          Jadwals jadwal = Jadwals.fromJson(_);
          Js.add(jadwal);
        }
      });
    });
  }

  Widget DaftarJadwal() {
    if (Js.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: Js.length,
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
                                        image: NetworkImage(Js[index]
                                            .object_dolanan
                                            .gambar_dolanan))))),
                        ListTile(
                          title: Text(Js[index].object_dolanan.nama_dolan,
                              style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500)), //nama dolanan
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child:
                                        Text(Js[index].tanggal)), //tanggal
                                Container(
                                    child: Text(Js[index].jam)), //jam
                                Container(
                                    //current member vs total member
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 2, bottom: 2),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5.0),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.group)),
                                        Text(Js[index]
                                                .current_member
                                                .toString() +
                                            '/' +
                                            Js[index]
                                                .object_dolanan
                                                .minimal_member
                                                .toString() +
                                            ' orang'),
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text(Js[index].lokasi), //lokasi
                                ),
                                Container(
                                    child:
                                        Text(Js[index].alamat)), //alamat
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
                                    onPressed: () {},
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
    // TODO: implement initState
    super.initState();
    bacaData();
  }
}

class CardJadwal extends StatelessWidget {
  final String title;
  final String description;

  const CardJadwal({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        onTap: () {
          // Handle onTap event if needed
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Cari(),
  ));
}
