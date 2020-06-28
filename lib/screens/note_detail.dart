import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_test/models/note.dart';
import 'package:todo_test/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController taskDurationController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;
    deadlineController.text = note.deadline;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                debugPrint("Save button clicked");
                _save();
              });
            },
            backgroundColor: Color(0xddc0c0c0),
            child: Icon(Icons.save),
          ),
          appBar: AppBar(
            backgroundColor: Color(0xfff3f3f5),
            title: Text(
              appBarTitle,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black45,
                  size: 20,
                ),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                ListTile(
                  title: Container(
                    color: Colors.white,
                    // margin: EdgeInsets.all(0),

                    child: Center(
                      child: DropdownButton(
                          hint: Text('Priority'),
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                          style: textStyle,
                          value: getPriorityAsString(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              debugPrint('User selected $valueSelectedByUser');
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    maxLines: null,
                    controller: titleController,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                  ),
                ),

                //datetime picker
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DateTimeField(
                    controller: deadlineController,
                    format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                    decoration: InputDecoration(
                        labelText: 'Pick the Deadline',
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        updateDeadline(DateTimeField.combine(date, time));
                        return DateTimeField.combine(date, time);
                      } else {
                        updateDeadline(currentValue);
                        return currentValue;
                      }
                    },
                  ),
                ),

                // Third Element
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Column(
                      children: <Widget>[
                        Text('Enter the duration for task'),
                        FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            Duration resultingDuration =
                                await showDurationPicker(
                              context: context,
                              initialTime: new Duration(minutes: 30),
                            );
                            // Scaffold.of(context).showSnackBar(new SnackBar(
                            //     content: new Text(
                            //         "Chose duration: $resultingDuration")));
                          },
                          tooltip: 'Popup Duration Picker',
                          child: new Icon(Icons.timer),
                        )
                      ],
                    )),

                //description field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 305.0),
                  child: TextField(
                    maxLines: null,
                    //expands: true,
                    controller: descriptionController,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDeadline(DateTime enteredDeadline) {
    String formattedDate =
        DateFormat("EEEE, MMMM d, yyyy 'at' h:mma").format(enteredDeadline);
    note.deadline = formattedDate;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
