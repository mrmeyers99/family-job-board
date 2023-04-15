import 'package:family_job_board/service/family_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../fire_auth.dart';
import '../widgets/menu_bar.dart';
import 'login_page.dart';

class FamilyPage extends StatefulWidget {
  final User user;

  const FamilyPage({required this.user});

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late User _currentUser;
  late Stream _familyStream;
  
  @override
  void initState() {
    _currentUser = widget.user;
    _familyStream = RecipeService().getFamily(_currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Settings'),
      ),
      drawer: MyMenuBar(user: _currentUser),
      body: StreamBuilder(stream: _familyStream, builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.docs[0].collections());
        }
        snapshot.data.docs[0].data();

        return snapshot.hasData ?
          ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return card("test", "test", context);
            },
          ) : const CircularProgressIndicator();
        }
      ));
  }

  Widget card(String image, String title, BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("asdfa"),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 38.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
