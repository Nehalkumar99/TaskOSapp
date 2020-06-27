import 'package:flutter/material.dart';
import 'package:todo_test/screens/note_list.dart';
//import 'package:todo_test/screens/note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProdMAX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: NoteList(),
    );
  }
}
