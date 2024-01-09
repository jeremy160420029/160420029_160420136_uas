// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable, avoid_print, annotate_overrides, camel_case_types, avoid_init_to_null, must_be_immutable

import 'dart:convert';
import 'package:dolanyuk/class/ngobrols.dart';
import 'package:dolanyuk/class/penggunas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Penggunas? pengguna_aktif = null;

class Ngobrol extends StatefulWidget {
  int jadwalID;
  int penggunaID;
  Ngobrol({super.key, required this.jadwalID, required this.penggunaID});

  @override
  State<Ngobrol> createState() => _NgobrolState();
}

class _NgobrolState extends State<Ngobrol> {
  String _temp = 'waiting API respond…';
  List<Ngobrols> obrolanList = [];
  String _errorMessage = '';
  String _txtIsi = '';

  TextEditingController obrolanController = TextEditingController();

  Future<List<Ngobrols>> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420136/dolanyuk/obrolan.php"),
      body: {'id': widget.jadwalID.toString()},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json['data'] != null) {
        List<dynamic> dataList = json['data'];
        List<Ngobrols> result =
            dataList.map((data) => Ngobrols.fromJson(data)).toList();
        return result;
      } else {
        setState(() {
          _errorMessage = 'Tidak ada data obrolan.';
        });
        return [];
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> cekPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
    return json_pengguna_aktif;
  }

  bacaData() {
    obrolanList.clear();
    Future<List<Ngobrols>> data = fetchData();
    data.then((List<Ngobrols> value) {
      setState(() {
        obrolanList = value;
        _temp = obrolanList.isNotEmpty ? obrolanList[0].isi : 'No data';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Party Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: obrolanList.isNotEmpty
                ? ListView.builder(
                    itemCount: obrolanList.length,
                    itemBuilder: (context, index) {
                      Ngobrols obrolan = obrolanList[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(obrolan
                                    .list_jadwals.object_pengguna.gambar ??
                                'https://chi-care.org/newdesign/wp-content/uploads/2023/05/Dummy-Person.png'),
                          ),
                          title: Text(obrolan
                              .list_jadwals.object_pengguna.nama_lengkap),
                          subtitle: Text(
                            obrolan.isi,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(_errorMessage),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: obrolanController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan obrolan baru...',
                    ),
                    onChanged: (value) {
                      _txtIsi = value;
                    },
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    kirimObrolan(_txtIsi.toString());
                  },
                  child: Text('Kirim'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void kirimObrolan(String isi) async {
    final response = await http.post(
      Uri.parse('https://ubaya.me/flutter/160420136/dolanyuk/add_obrolan.php'),
      body: {
        'jadwal': widget.jadwalID.toString(),
        'pengguna': widget.penggunaID.toString(),
        'isi': isi
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil mengirim pesan'),
        ));

        // Navigator.pushReplacement ke halaman Ngobrol dengan parameter jadwalID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Ngobrol(
                jadwalID: widget.jadwalID, penggunaID: pengguna_aktif!.id),
            maintainState: false,
          ),
        );
      } else if (json['result'] == 'fail') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json['message']),
        ));
      }
    } else {
      throw Exception('Failed to read API');
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
}
