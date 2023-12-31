// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import, camel_case_types, unused_field, prefer_final_fields, avoid_print, unnecessary_const, avoid_unnecessary_containers, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:dolanyuk/class/penggunas.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/profil.dart';
import 'package:dolanyuk/screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class mySignIn extends StatelessWidget {
  const mySignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DolanYuk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: signIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => signInState();
}

class signInState extends State<signIn> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void login() async {
    final response = await http.post(
        Uri.parse('https://ubaya.me/flutter/160420136/dolanyuk/login.php'),
        body: {'email': _email, 'password': _password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("pengguna_aktif", jsonEncode(json['data']));
        main();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email atau password salah')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.purple[50],
                ),
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(35),
                height: 450,
                child: Column(
                  children: [
                    // Judul
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text('DolanYuk',
                          style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.w700)),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Text Field Email
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                      labelText: 'Email',
                                    ),
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email harus diisi';
                                      }
                                      return null;
                                    })),
                            // Text Field Password
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
                            // Button Action
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Sign Up
                                    Container(
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Size(120, 50)),
                                        ),
                                        child: Text('Sign Up'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      signUp()));
                                        },
                                      ),
                                    ),
                                    // Sign In
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
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
                                        child: Text('Sign In'),
                                        onPressed: () {
                                          if (_formKey.currentState != null &&
                                              !_formKey.currentState!
                                                  .validate()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Harap Isian diperbaiki')));
                                          } else {
                                            login();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ))
                  ],
                ))));
  }
}
