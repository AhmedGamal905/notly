import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Models/NoteModel.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Services/FirebaseServices.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomField.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _noteController;
  int colorIndex;
  List<ColorsModel> colors;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    colorIndex = 0;
    colors = [
      ColorsModel(color: '0xfffea632'),
      ColorsModel(color: '0xfffff7ab'),
      ColorsModel(color: '0xffacebba'),
      ColorsModel(color: '0xffb2e1ff'),
      ColorsModel(color: '0xffdbc0ff'),
      ColorsModel(color: '0xfff29191'),
    ];
  }

  void saveNote() {
    String selectedColor = colors[colorIndex].color.toString();
    if (!_formKey.currentState.validate()) return;
    FirebaseServices().addUserNote(Note(
      title: _titleController.text,
      note: _noteController.text,
      color: selectedColor,
      date: DateTime.now().toString(),
    ).toJson());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  void dispose() {
    super.dispose();
    _titleController?.dispose();
    _noteController?.dispose();
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
            "Note",
            style: TextStyle(
              color: CColors.whiteTheme,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
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
                    return 'Enter your note title';
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
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: colors.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: (100 / 75),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ColorPickerContainer(
                    isSelected: colorIndex == index,
                    color: colors[index].color,
                    onTap: () {
                      setState(() => colorIndex = index);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Save",
                onTap: saveNote,
                color: CColors.lightRedTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerContainer extends StatelessWidget {
  final String color;
  final Function onTap;
  final bool isSelected;

  const ColorPickerContainer({
    @required this.color,
    @required this.onTap,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(int.parse(color)).withOpacity(0.5)
                  : Color(int.parse(color)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorsModel {
  String color;
  ColorsModel({this.color});
}
