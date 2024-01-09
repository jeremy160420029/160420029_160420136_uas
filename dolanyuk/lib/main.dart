// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, unnecessary_new, unused_import, depend_on_referenced_packages, non_constant_identifier_names, avoid_init_to_null

import 'dart:convert';

import 'package:dolanyuk/class/penggunas.dart';
import 'package:dolanyuk/screen/buat.dart';
import 'package:dolanyuk/screen/cari.dart';
import 'package:dolanyuk/screen/jadwal.dart';
import 'package:dolanyuk/screen/ngobrol.dart';
import 'package:dolanyuk/screen/profil.dart';
import 'package:dolanyuk/screen/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Penggunas? pengguna_aktif = null;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  cekPengguna().then((String result) {
    if (result == '') {
      runApp(const mySignIn());
    } else {
      pengguna_aktif = Penggunas.fromJson(jsonDecode(result));
      runApp(const MyApp());
    }
  });
}

Future<String> cekPengguna() async {
  final prefs = await SharedPreferences.getInstance();
  String json_pengguna_aktif = prefs.getString("pengguna_aktif") ?? '';
  return json_pengguna_aktif;
}

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("pengguna_aktif");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DolanYuk',
      routes: {
        'jadwal': (context) => Jadwal(),
        'cari': (context) => Cari(),
        'profil': (context) => Profil(),
        'buat': (context) => buat(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [Jadwal(), Cari(), Profil()];
  final List<String> _title = ['Jadwal', 'Cari', 'Profil'];

  // Bottom Menu
  BottomNavigationBar myBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: Colors.deepPurpleAccent,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "Jadwal",
          icon: Icon(Icons.calendar_month),
        ),
        BottomNavigationBarItem(
          label: "Cari",
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(label: "Profil", icon: Icon(Icons.person)),
      ],
    );
  }

  // Drawer
  Drawer myDrawer() {
    main();

    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(pengguna_aktif!.nama_lengkap),
              accountEmail: Text(pengguna_aktif!.email),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(pengguna_aktif!.gambar ??
                      "https://chi-care.org/newdesign/wp-content/uploads/2023/05/Dummy-Person.png"))),
          ListTile(
              title: new Text("Buat Jadwal"),
              leading: new Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, 'buat');
              }),
          ListTile(
              title: new Text("Jadwal"),
              leading: new Icon(Icons.calendar_month),
              onTap: () {
                Navigator.pushNamed(context, 'jadwal');
              }),
          ListTile(
              title: new Text("Cari"),
              leading: new Icon(Icons.search),
              onTap: () {
                Navigator.pushNamed(context, 'cari');
              }),
          ListTile(
              title: new Text("Profil"),
              leading: new Icon(Icons.person),
              onTap: () {
                Navigator.pushNamed(context, 'profil');
              }),
          ListTile(
              title: new Text("Logout", style: TextStyle(color: Colors.red)),
              leading: new Icon(Icons.exit_to_app, color: Colors.red),
              onTap: () {
                logout();
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('DolanYuk'),
      ),
      drawer: myDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: myBottomNavigationBar(),
    );
  }
}
