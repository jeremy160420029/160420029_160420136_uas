// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class buat extends StatefulWidget {
  const buat({super.key});

  @override
  State<buat> createState() => _buatState();
}

class _buatState extends State<buat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Buat Jadwal')),
      body: Text('Buat')
    );
  }
}