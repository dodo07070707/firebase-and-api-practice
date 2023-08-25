import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List names = [];

  Future<void> _callAPI() async {
    for (int index = 1; index <= 13; index++) {
      var url = Uri.parse(
        'https://open.neis.go.kr/hub/schoolInfo?KEY=cd3d82c9b70b4de3a1591e48d6507ea2&Type=json&pSize=1000&pIndex=$index',
      );
      var response = await http.get(url);
      List arr = jsonDecode(response.body)['schoolInfo'][1]['row'];
      for (var schoolData in arr) {
        String schoolName = schoolData['SCHUL_NM'];
        names.add(schoolName);
      }
    }
    print('lengths :');
    print(names.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('http Example'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _callAPI,
              child: const Text('Call API'),
            ),
          ),
          FutureBuilder(
              future: _callAPI(),
              builder: (context, s) {
                return Text(
                  '$names',
                  style: const TextStyle(color: Colors.black),
                );
              }),
        ],
      ),
    );
  }
}
