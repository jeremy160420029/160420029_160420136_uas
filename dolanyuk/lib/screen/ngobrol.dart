import 'dart:convert';

import 'package:dolanyuk/class/ngobrols.dart';
import 'package:dolanyuk/class/penggunas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Penggunas? pengguna_aktif = null;

class Ngobrol extends StatefulWidget {
  int jadwalID;
  Ngobrol({Key? key, required this.jadwalID}) : super(key: key);

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
                            backgroundImage: NetworkImage(obrolanList[index]
                                    .list_jadwals
                                    .object_pengguna
                                    .gambar ??
                                ''),
                          ),
                          title: Text(obrolan.isi),
                          subtitle: Text(obrolan
                              .list_jadwals.object_pengguna.nama_lengkap),
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
                    kirimObrolan(
                        obrolanList[0].list_jadwals.list_jadwal_id.toString(),
                        _txtIsi.toString());
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

  void kirimObrolan(String listJadwal, String isi) async {
    final response = await http.post(
      Uri.parse('https://ubaya.me/flutter/160420136/dolanyuk/add_obrolan.php'),
      body: {'list_jadwal': listJadwal, 'isi': isi},
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
            builder: (context) =>
                Ngobrol(jadwalID: obrolanList[0].list_jadwals.object_jadwal.id),
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

void main() {
  runApp(
    MaterialApp(
      home: Ngobrol(jadwalID: 1),
    ),
  );
}
