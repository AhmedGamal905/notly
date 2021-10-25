import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Authentication.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Models/NoteModel.dart';
import 'package:notly/Screens/Auth/Login.dart';
import 'package:intl/intl.dart';
import 'package:notly/Screens/ViewNote.dart';
import 'package:notly/Services/FirebaseServices.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Auth _auth = Auth();
  final firestoreInstance = FirebaseFirestore.instance;

  void logOut() async {
    _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CColors.whiteTheme),
        backgroundColor: CColors.lightRedTheme,
        elevation: 0,
        title: Title(
          color: CColors.blackTheme,
          child: Text(
            "Notes",
            style: TextStyle(
              color: CColors.whiteTheme,
              fontSize: 25,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/AddNote'),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListTile(
                title: Text(
                  "Hi, " + "Ahmed",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "Ahmed.gamal9@hotmail.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.wb_sunny_outlined,
                color: CColors.lightRedTheme,
              ),
              title: Text(
                'Theme',
                style: TextStyle(
                  color: CColors.textLigterTheme,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.door_back_door_outlined,
                color: CColors.lightRedTheme,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: CColors.textLigterTheme,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'LogOut!',
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: logOut,
                        child: Text(
                          'Logout',
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
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices().getUserNotes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error in receiving Notes: ${snapshot.error}'),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Not connected to the Stream or null');
            case ConnectionState.waiting:
              return Text('Awaiting for interaction');
            case ConnectionState.active:
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return GridView.builder(
                    itemCount: snapshot.data.docs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (100 / 75),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      Note note =
                          Note.fromJson(snapshot.data.docs[index].data());
                      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
                          .parse(note.date);
                      DateTime inputDate = DateTime.parse(parseDate.toString());
                      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
                      String formatedDate = outputFormat.format(inputDate);
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewNote(
                              id: snapshot.data.docs[index].id,
                              title: note.title,
                              note: note.note,
                              color: note.color,
                            ),
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(note.color)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      strutStyle: StrutStyle(fontSize: 12.0),
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        text: note.title,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      note.note,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    formatedDate,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return Center(
                child: Text(
                  "No notes available try adding some notes",
                ),
              );

            case ConnectionState.done:
              return Text('Streaming is done');
          }
          return Center(
            child: Text("No notes available"),
          );
        },
      ),
    );
  }
}
