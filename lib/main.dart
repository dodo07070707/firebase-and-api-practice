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
  List<String> school_names = [];
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
        school_names.add(schoolName);
      }
    }
    names = names.toSet().toList();
    names.sort();
    print('lengths :');
    print(names.length);
  }

  List<String> filteredSchoolNames = [];

  void updateFilteredSchools(String input) {
    setState(() {
      filteredSchoolNames = school_names
          .where((schoolName) =>
              schoolName.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _callAPI,
              child: const Text('Call API'),
            ),
          ),
          TextField(
            onChanged: (input) {
              updateFilteredSchools(input);
            },
            decoration: const InputDecoration(
              labelText: '학교명을 입력하세요',
            ),
          ),
          ListView.builder(
            itemCount: filteredSchoolNames.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredSchoolNames[index]),
                onTap: () {
                  print('selected!');
                },
              );
            },
          ),

          /*
              FutureBuilder(
                  future: _callAPI(),
                  builder: (context, s) {
                    return Text(
                      '$names',
                      style: const TextStyle(color: Colors.black),
                    );
                  }),*/
        ],
      ),
    );
  }
}
