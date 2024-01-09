import 'dart:convert';

import 'package:dolanyuk/class/list_jadwals.dart';
import 'package:dolanyuk/class/penggunas.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/ngobrol.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Penggunas? pengguna_aktif = null;

class Ruangan extends StatefulWidget {
  int jadwalID;
  Ruangan({super.key, required this.jadwalID});
  @override
  State<StatefulWidget> createState() {
    return _RuanganState();
  }
}

class _RuanganState extends State<Ruangan> {
  String _temp = 'waiting API respond…';
  Future<List<ListJadwals>> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420136/dolanyuk/ruangan.php"),
      body: {'id': widget.jadwalID.toString()},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> dataList = json['data'];
      List<ListJadwals> result =
          dataList.map((data) => ListJadwals.fromJson(data)).toList();
      return result;
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
    LJs.clear();
    Future<List<ListJadwals>> data = fetchData(); // Update the type
    data.then((List<ListJadwals> value) {
      // Handle the List<ListJadwals> result directly
      for (var listjadwal in value) {
        LJs.add(listjadwal);
      }
      setState(() {
        _temp = LJs.isNotEmpty
            ? LJs[0].object_pengguna.nama_lengkap
            : 'No data'; // Update indexing logic
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil masuk ke dalam Ruangan'),
        ));

        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(), maintainState: false));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konco Dolanan')),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: FutureBuilder<List<ListJadwals>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<ListJadwals> LJs = snapshot.data!;
                    return tampilData(LJs);
                  } else {
                    return const Text("No data");
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tampilData(List<ListJadwals> LJs) {
    if (LJs.isEmpty) {
      return const CircularProgressIndicator();
    }

    bool isCurrentUserInList = LJs.any((jadwal) =>
        jadwal.object_pengguna.nama_lengkap == pengguna_aktif?.nama_lengkap);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: LJs.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            LJs[index].object_pengguna.gambar ?? ''),
                        radius: 30,
                      ),
                      title: GestureDetector(
                        child: Text(LJs[index].object_pengguna.nama_lengkap),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Ngobrol(jadwalID: LJs[0].object_jadwal.id),
                            ),
                          );
                        },
                      ),
                      subtitle: Text(LJs[index].object_pengguna.email),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Current Members'),
                Text(
                  LJs[0].object_jadwal.current_member.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text('Minimal Members'),
                Text(
                  LJs[0].object_jadwal.object_dolanan.minimal_member.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (isCurrentUserInList) {
              // Jika pengguna aktif ada dalam daftar, navigasikan ke obrolan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Ngobrol(jadwalID: LJs[0].object_jadwal.id),
                ),
              );
            } else {
              join(pengguna_aktif?.id.toString(),
                  LJs[0].object_jadwal.id.toString());
            }
          },
          child: Text(isCurrentUserInList ? 'Buka Obrolan' : 'Join'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Kembali'),
        ),
      ],
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
