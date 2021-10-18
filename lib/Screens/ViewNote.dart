import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Authentication.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomField.dart';

class ViewNote extends StatefulWidget {
  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  final firestoreInstance = FirebaseFirestore.instance;
  // Auth _auth = Auth();
  final userUid = Auth().getUser().uid;
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.delete_outline,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: CustomTextField(
                hint: "Enter Note Title",
                icon: Icon(
                  Icons.post_add_rounded,
                  color: CColors.textFelidHintTheme,
                ),
                validator: null,
                controller: null,
                obscureText: false),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              // controller: ,
              maxLines: 15,
              textDirection: TextDirection.ltr,
              cursorColor: CColors.lightRedTheme,
              decoration: InputDecoration(
                hintText: "Enter your note",
                hintStyle: TextStyle(
                  color: CColors.textFelidHintTheme,
                  fontWeight: FontWeight.w400,
                  fontFamily: "SFProText",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
                filled: true,
                fillColor: CColors.textFelidTheme,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CColors.textFelidTheme,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CColors.textFelidTheme,
                  ),
                ),
                errorStyle: TextStyle(
                  color: CColors.lightRedTheme,
                  fontSize: 12,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CColors.lightRedTheme,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CColors.textFelidTheme,
                  ),
                ),
                contentPadding: EdgeInsets.all(8.0),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: CColors.lightRedTheme,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "Save",
              onTap: () {},
              color: CColors.lightRedTheme,
            ),
          ),
        ],
      ),
    );
  }
}
