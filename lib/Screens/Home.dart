import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notly/Provider/ThemeProdiver.dart';
import 'package:notly/Services/Authentication.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Models/NoteModel.dart';
import 'package:notly/Screens/Auth/Login.dart';
import 'package:intl/intl.dart';
import 'package:notly/Screens/ViewNote.dart';
import 'package:notly/Services/FirebaseServices.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Auth _auth = Auth();
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  PackageInfo _info;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      PackageInfo info = await PackageInfo.fromPlatform();
      setState(() => _info = info);
    });
  }

  void _logOut() {
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
    final Size size = MediaQuery.of(context).size;
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
        backgroundColor: CColors.lightRedTheme,
        child: const Icon(
          Icons.add,
          color: CColors.whiteTheme,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/notes.svg",
                height: 150,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            ListTile(
              leading: Icon(
                Icons.wb_sunny_outlined,
                color: CColors.lightRedTheme,
              ),
              title: Text(
                context.watch<ThemeProvider>().nameTheme,
                style: TextStyle(
                  color: CColors.textLigterTheme,
                ),
              ),
              onTap: () => context.read<ThemeProvider>().changeTheme(),
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
                        onPressed: _logOut,
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
            Divider(
              thickness: 0.5,
              endIndent: 16,
              indent: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "V ${_info?.version ?? '0.0.1'}",
                style: TextStyle(
                  color: CColors.textLigterTheme,
                ),
              ),
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
              return Center(
                child: Container(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: CColors.lightRedTheme,
                  ),
                ),
              );
            case ConnectionState.active:
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return StaggeredGridView.countBuilder(
                    itemCount: snapshot.data.docs.length,
                    crossAxisSpacing: 8,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 8,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    crossAxisCount: 4,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Note note =
                          Note.fromJson(snapshot.data.docs[index].data());
                      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss")
                          .parse(note.date);
                      DateTime inputDate = DateTime.parse(parseDate.toString());
                      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
                      String formatedDate = outputFormat.format(inputDate);
                      return GestureDetector(
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
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(int.parse(note.color)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            note.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: CColors.noteTextTheme,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    formatedDate,
                                    style: TextStyle(
                                      color: CColors.lightBlackTheme,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                  Divider(
                                    color: CColors.whiteTheme,
                                    thickness: 0.5,
                                  ),
                                ],
                              ),
                              Text(
                                note.note,
                                style: TextStyle(
                                  height: 1.2,
                                  color: CColors.noteTextTheme,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 8,
                              )
                            ],
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
