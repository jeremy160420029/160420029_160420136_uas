// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dolanyuk/class/penggunas.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/update_password.dart';
import 'package:dolanyuk/screen/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Penggunas? pengguna_aktif = null;

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late Future<String> _userDataFuture;

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
              pengguna_aktif = Penggunas.fromJson(jsonDecode(result));

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pengguna_aktif?.gambar ??
                        "https://chi-care.org/newdesign/wp-content/uploads/2023/05/Dummy-Person.png"),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nama Lengkap Pengguna:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    pengguna_aktif?.nama_lengkap ?? 'Nama Pengguna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email Pengguna:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    pengguna_aktif?.email ?? 'Email Pengguna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the update profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfil()),
                      );
                    },
                    child: Text('Ubah Profil'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the update profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePassword()),
                      );
                    },
                    child: Text('Ubah Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the update profile page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                    child: Text('Kembali ke Halaman Utama'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
