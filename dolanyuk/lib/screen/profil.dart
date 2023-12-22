// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class profil extends StatefulWidget {
  const profil({super.key});

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profil')
    );
  }
}