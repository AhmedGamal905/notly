import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Models/NoteModel.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Services/FirebaseServices.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomField.dart';

class ViewNote extends StatefulWidget {
  final String id, title, note, color;
  ViewNote({this.id, this.title, this.note, this.color});
  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _titleController.text = widget.title;
    _noteController.text = widget.note;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController?.dispose();
    _noteController?.dispose();
  }

  void updateNote() {
    if (!_formKey.currentState.validate()) return;
    FirebaseServices().updateUserNote(
      Note(
        title: _titleController.text,
        note: _noteController.text,
        color: widget.color,
        date: DateTime.now().toString(),
      ).toJson(),
      widget.id,
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CColors.lightRedTheme,
        title: Title(
          color: CColors.blackTheme,
          child: Text(
            widget.title,
            style: TextStyle(
              color: CColors.whiteTheme,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'Remove note',
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          FirebaseServices().removeUserNote(widget.id);
                          Navigator.pushReplacementNamed(context, '/Home');
                        },
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: CColors.lightRedTheme,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: CColors.lightRedTheme,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(
                Icons.delete_outline,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: CustomTextField(
                maxLines: 1,
                hint: "Enter Note Title",
                icon: Icon(
                  Icons.post_add_rounded,
                  color: CColors.textFelidHintTheme,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your note first';
                  }
                  return null;
                },
                controller: _titleController,
                obscureText: false,
              ),
            ),
            CustomTextField(
              hint: 'Enter your note',
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter your note first';
                }
                return null;
              },
              controller: _noteController,
              obscureText: false,
              maxLines: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Save",
                onTap: updateNote,
                color: CColors.lightRedTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
