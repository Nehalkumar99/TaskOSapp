import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_test/models/note.dart';
import 'package:todo_test/utils/database_helper.dart';
import 'package:todo_test/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is the Drawer'),
              RaisedButton(
                onPressed: () {},
                child: const Text('Close Drawer'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black38),
          elevation: 20,
          title: Text(
            'PRODMAX',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          backgroundColor: Color(0xfff3f3f5)),
      body: getNoteListView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');

          navigateToDetail(
              Note(
                '',
                '',
                2,
              ),
              'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
        backgroundColor: Color(0xddc0c0c0),
        splashColor: Colors.teal,
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              //child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Column(
              children: <Widget>[
                Text(
                  'Saved - ' + this.noteList[position].date,
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Task Duration\n' + this.noteList[position].duration,
                  style: TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Deadline',
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.w600),
                ),
                Text(
                  this.noteList[position].deadline,
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Color(0xbbc0c0c0),
              ),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetail(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  // Icon getPriorityIcon(int priority) {
  //   switch (priority) {
  //     case 1:
  //       return Icon(Icons.play_arrow);
  //       break;
  //     case 2:
  //       return Icon(Icons.keyboard_arrow_right);
  //       break;

  //     default:
  //       return Icon(Icons.keyboard_arrow_right);
  //   }
  // }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
      backgroundColor: Color(0xffca9c13),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
