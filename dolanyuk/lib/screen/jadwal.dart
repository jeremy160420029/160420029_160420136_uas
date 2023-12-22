// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class jadwal extends StatefulWidget {
  const jadwal({super.key});

  @override
  State<jadwal> createState() => _jadwalState();
}

class _jadwalState extends State<jadwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Jadwal'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'buat');
        },
        tooltip: 'Buat Jadwal',
        child: const Icon(Icons.edit),
      ),
    );
  }
}