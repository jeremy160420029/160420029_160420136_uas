import 'dart:convert';

import 'package:dolanyuk/class/list_jadwals.dart';
import 'package:dolanyuk/screen/ngobrol.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // Future<String> fetchData() async {
  //   final response = await http.post(
  //       Uri.parse("https://ubaya.me/flutter/160420136/dolanyuk/ruangan.php"),
  //       body: {'id': widget.jadwalID.toString()});
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }
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
            ? LJs[0].nama_lengkap
            : 'No data'; // Update indexing logic
      });
    });
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
                        backgroundImage: NetworkImage(LJs[index].gambar ?? ''),
                        radius: 30,
                      ),
                      title: GestureDetector(
                        child: Text(LJs[index].nama_lengkap),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Ngobrol(),
                            ),
                          );
                        },
                      ),
                      subtitle: Text(LJs[index].email),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Ngobrol(),
              ),
            );
          },
          child: Text('Join'),
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
}
