// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dolanyuk/class/jadwals.dart';
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
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var jadwal in json['data']) {
        Jadwals js = Jadwals.fromJson(jadwal);
        Js.add(js);
      }
      setState(() {
        _temp = Js[30].lokasi;
      });
    });
  }

  Widget DaftarJadwal(data) {
    List<Jadwals> Js = [];
    Map json = jsonDecode(data);
    for (var jadwal in json['data']) {
      Jadwals js = Jadwals.fromJson(jadwal);
      Js.add(js);
    }
    return ListView.builder(
        itemCount: Js.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ListTile(
              //   leading: Icon(Icons.movie, size: 30),
              //   title: GestureDetector(
              //       child: Text(Js[index].lokasi),
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 DetailPop(movieID: Js[index].id),
              //           ),
              //         );
              //       }),
              //   subtitle: Text(Js[index].overview),
              // ),
            ],
          ));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Cari Jadwal')),
        body: ListView(children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Judul mengandung kata:',
            ),
            onFieldSubmitted: (value) {
              setState(() {
                _txtCari = value;
              });
            },
          ),
          Container(
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error! ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return DaftarJadwal(snapshot.data.toString());
                      } else {
                        return const Text("No data");
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }))
        ]));
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
