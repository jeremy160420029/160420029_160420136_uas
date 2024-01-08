// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, non_constant_identifier_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, sort_child_properties_last, unused_local_variable, avoid_print, annotate_overrides, camel_case_types, avoid_init_to_null

import 'dart:convert';
import 'dart:math';
import 'package:dolanyuk/class/dolanans.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/update_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../class/penggunas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin.dart';

class buat extends StatefulWidget {
  const buat({super.key});

  @override
  State<buat> createState() => _buatState();
}

Penggunas? pengguna_aktif = null;

class _buatState extends State<buat> {
  final _formKey = GlobalKey<FormState>();
  
  Widget _widgetComboDolanans = DropdownButtonFormField(items: [], onChanged: (_) {}, decoration: InputDecoration(border: const OutlineInputBorder(),),);
  
  final TextEditingController _controllerTanggal = TextEditingController();
  final TextEditingController _controllerJam = TextEditingController();
  String _alamat = '';
  String _lokasi = '';
  int _idDolanan = 0;
  final TextEditingController _controllerMinimalMember = TextEditingController();
  
  Future<String> cekPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
    return json_pengguna_aktif;
  }

  Future<List> daftarDolanans() async {
    Map json;
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420136/dolanyuk/dolanan_list.php"));
    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      print(json);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  void generateComboDolanans() {
    List<Dolanans> dolanans;
    daftarDolanans().then((value) {
    dolanans = List<Dolanans>.from(value.map((i) {return Dolanans.fromJson(i);}));    
    setState(() {
      var init_dolanan = dolanans[0]; //Dolanan Pertama buat init value
      _idDolanan = init_dolanan.id; //init id dolanan
      _controllerMinimalMember.text = init_dolanan.minimal_member.toString(); //init minim member
      _widgetComboDolanans = DropdownButtonFormField(
           decoration: InputDecoration(
            labelStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500),
            labelText: 'Dolan Utama',
            border: const OutlineInputBorder(),
            ),
          hint: Text(init_dolanan.nama_dolan),
          value: init_dolanan.id,
          items: dolanans.map((dolanan) {
            return DropdownMenuItem(
            child: Column(children: <Widget>[
              Text(dolanan.nama_dolan, overflow: TextOverflow.visible),
            ]),
            value: dolanan.id,
            );
          }).toList(),
          onChanged: (id) {
            setState(() {
              _idDolanan = id!;
              _controllerMinimalMember.text = dolanans.firstWhere((dolanan) => dolanan.id == id).minimal_member.toString();
            });
          });
    });
  });
 }

  void submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420136/dolanyuk/add_jadwal.php"),
      body: {
        'tanggal':_controllerTanggal.text,
        'jam':_controllerJam.text,
        'lokasi': _lokasi,
        'alamat': _alamat,
        'dolanans_id': _idDolanan.toString(),
        'pengguna_id': pengguna_aktif!.id.toString(),
      });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sukses Menambah Jadwal')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(), maintainState: false));
      }
    } else {
    throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      cekPengguna().then((String result) {pengguna_aktif = Penggunas.fromJson(jsonDecode(result));});
      generateComboDolanans();
    });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Jadwal'),),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text("Bikin jadwal dolanan yuk!"),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Text Field Tanggal Dolan
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                            readOnly: true,
                            controller: _controllerTanggal,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                              labelText: 'Tanggal Dolan',
                            ),
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2200))
                                .then((value) {
                              setState(() {
                                  _controllerTanggal.text = DateFormat('EEEE, dd MMMM yyyy').format(value!);
                                });
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal dolan harus diisi';
                              }
                              return null;
                            })
                      ),
                      // Time Picker Jam Dolan
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                            readOnly: true,
                            controller: _controllerJam,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.watch_later),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                              labelText: 'Jam Dolan',
                            ),
                            onTap: () {
                              showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,)
                                .then((value) {
                              setState(() {
                                _controllerJam.text = value.toString().substring(10, 15);       
                                });
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jam dolan harus diisi';
                              }
                              return null;
                            })
                      ),
                      // Text Field Lokasi Dolan
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                              labelText: 'Lokasi Dolan',
                            ),
                            onChanged: (value) {
                              _lokasi = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'lokasi dolan harus diisi';
                              }
                              return null;
                            })
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        alignment: Alignment.topLeft,
                        child: Text('Contoh Starbucks, McDonald, Cafe Cozy')
                      ),
                      // Text Field Alamat Dolan
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                              labelText: 'Alamat Dolan',
                            ),
                            onChanged: (value) {
                              _alamat = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat dolan harus diisi';
                              }
                              return null;
                            })
                      ),
                      //Dropdown Dolan
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: _widgetComboDolanans,
                      ),
                      //Minimal Member
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                            readOnly: true,
                            controller: _controllerMinimalMember,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                              labelText: 'Minimal Member',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Minimal member harus diisi';
                              }
                              return null;
                            })
                      ),
                      // Button Buat
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Size(120, 50)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.purple),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.white),
                            ),
                            child: Text('Buat Jadwal'),
                            onPressed: () {
                              if (_formKey.currentState != null &&
                                  !_formKey.currentState!
                                      .validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                            'Harap Isian diperbaiki')));
                              } else {
                                submit();
                              }
                            },
                          ),
                        )
                    ],
                  )
                )
              ]
              ),
          ),
        )
      )
    );
  }
}