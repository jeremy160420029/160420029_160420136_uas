// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dolanyuk/class/pengguna.dart';
import 'package:dolanyuk/screen/profil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Pengguna? pengguna_aktif = null;

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  late Future<String> _userDataFuture;
  String _password = '';
  String _ulang_password = '';

  void update() async {
    final response = await http.post(
      Uri.parse(
          'https://ubaya.me/flutter/160420136/dolanyuk/update_password.php'),
      body: {'email': pengguna_aktif?.email, 'password': _password},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Proses update password telah berhasil dilakukan'),
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

    existingUser.password = _password;

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
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      labelText: 'Password',
                                    ),
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password harus diisi';
                                      }
                                      return null;
                                    })),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      labelText: 'Ulangi Password',
                                    ),
                                    onChanged: (value) {
                                      _ulang_password = value;
                                    },
                                    validator: (value) {
                                      if (value != _password) {
                                        return 'Ulangi password tidak sesuai dengan Password';
                                      } else if (value == null ||
                                          value.isEmpty) {
                                        return 'Ulangi password harus diisi';
                                      }
                                      return null;
                                    })),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState != null &&
                                    !_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Harap Isian diperbaiki')));
                                } else {
                                  update();
                                }
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
                        )),
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
