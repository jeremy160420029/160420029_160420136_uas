// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dolanyuk/class/pengguna.dart';
import 'package:dolanyuk/screen/profil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Pengguna? pengguna_aktif = null;

class UpdateProfil extends StatefulWidget {
  const UpdateProfil({Key? key}) : super(key: key);

  @override
  State<UpdateProfil> createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
  late Future<String> _userDataFuture;
  String _nama_lengkap = '';
  String _photo_url = '';

  void update() async {
    final response = await http.post(
      Uri.parse(
          'https://ubaya.me/flutter/160420136/dolanyuk/update_profile.php'),
      body: {
        'email': pengguna_aktif?.email,
        'nama_lengkap': _nama_lengkap,
        'gambar': _photo_url
      },
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Proses update telah berhasil dilakukan'),
        ));

        await updateSharedPreferences();

        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Profil()));
      } else if (json['result'] == 'fail') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json['message']),
        ));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> updateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonPenggunaAktif = prefs.getString("pengguna_aktif") ?? '';
    Pengguna existingUser = Pengguna.fromJson(jsonDecode(jsonPenggunaAktif));

    existingUser.nama_lengkap = _nama_lengkap;
    existingUser.gambar = _photo_url;

    prefs.setString("pengguna_aktif", jsonEncode(existingUser.toJson()));
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = cekPengguna();
  }

  Future<String> cekPengguna() async {
    final prefs = await SharedPreferences.getInstance();
    String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
    return json_pengguna_aktif;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String result = snapshot.data as String;
              pengguna_aktif = Pengguna.fromJson(jsonDecode(result));

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(pengguna_aktif?.gambar ??
                          "https://chi-care.org/newdesign/wp-content/uploads/2023/05/Dummy-Person.png"),
                      radius: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: pengguna_aktif?.nama_lengkap ?? '',
                        onChanged: (value) {
                          _nama_lengkap = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nama Pengguna',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        initialValue: pengguna_aktif?.email ?? '',
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email Pengguna',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Photo URL',
                          hintText: 'Enter Photo URL',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _photo_url = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        update();
                      },
                      child: Text('Simpan'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Kembali'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
