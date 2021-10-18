import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Authentication.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Models/NoteModel.dart';
import 'package:notly/Screens/Auth/Login.dart';
import 'package:intl/intl.dart';
import 'package:notly/Services/FirebaseServices.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Auth _auth = Auth();
  final _userUid = Auth().getUser().uid;
  final firestoreInstance = FirebaseFirestore.instance;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String currentDate = formatter.format(now);

  void logOut() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogIn(),
      ),
    );
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    List _userList = Provider.of<List<Note>>(context);
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
      body: GridView.builder(
        itemCount: _userList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (100 / 75),
        ),
        itemBuilder: (BuildContext context, int index) {
          // _userList.length
          return Padding(
            padding: const EdgeInsets.all(6),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/ViewNote'),
              child: Container(
                decoration: BoxDecoration(
                  color: CColors.orangeTheme,
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
                            text: _userList[index].title,
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
                          _userList[index].note,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _userList[index].date,
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
      ),
    );
  }
}
