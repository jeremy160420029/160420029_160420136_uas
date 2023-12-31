// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_import, camel_case_types, unused_field, prefer_final_fields, avoid_print, unnecessary_const, avoid_unnecessary_containers, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:dolanyuk/class/penggunas.dart';
import 'package:dolanyuk/main.dart';
import 'package:dolanyuk/screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  String _nama_lengkap = '';
  String _email = '';
  String _password = '';
  String _ulang_password = '';

    void register() async {
    final response = await http.post(
      Uri.parse('https://ubaya.me/flutter/160420136/dolanyuk/register.php'),
      body: {
        'email':_email,
        'nama_lengkap':_nama_lengkap,
        'password':_password
      });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proses sign up telah berhasil dilakukan, silahkan sign in')));
        Navigator.pop(context);
      } 
      else if(json['result'] == 'fail'){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json['message'])));
      }
    } 
    else {
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
          child: Column(
            children: [
              // Judul
              Container(
                alignment: Alignment.topLeft,
                child: Text('SignUp', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
              ),
               // Sub Judul
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: Text('Sebelum nikmatin fasilitas DolanYuk, bikin akun yuk!'),
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
                        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                      })
                    ),
                    // Text Field Nama Lengkap
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        labelText: 'Nama Lengkap',
                      ),
                      onChanged: (value) {
                        _nama_lengkap = value;
                      },  
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama harus diisi';
                        }
                        return null;
                      })
                    ),
                    // Text Field Password
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
                      })
                    ),
                    // Text Field Ulangi Password
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        labelText: 'Ulangi Password',
                      ),
                      onChanged: (value) {
                        _ulang_password = value;
                      },  
                      validator: (value) {
                        if (value != _password) {
                            return 'Ulangi password tidak sesuai dengan Password';
                        }
                        else if (value == null || value.isEmpty) {
                          return 'Ulangi password harus diisi';
                        }
                        return null;
                      })
                    ),
                    // Button Action
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Sign Up
                          Container(
                            child:OutlinedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.resolveWith((states) => Size(120, 50)),
                              ),
                              child: Text('Kembali'),
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                            ),
                          ),
                          // Sign In
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.resolveWith((states) => Size(120, 50)),
                                backgroundColor:MaterialStateProperty.resolveWith((states) => Colors.purple),
                                foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                              ),
                              child: Text('Sign Up'),
                              onPressed: () {
                                if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Harap Isian diperbaiki')));
                                }
                                else {
                                  register();
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ),
                  ],  
                )
              )
            ],
          ))
        )
    );
  }
}