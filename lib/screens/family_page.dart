import 'package:family_job_board/service/family_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../fire_auth.dart';
import '../model/child.dart';
import '../model/family.dart';
import '../widgets/menu_bar.dart';
import 'edit_child_page.dart';
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

  final _log = Logger('_FamilyPageState');

  @override
  void initState() {
    _currentUser = widget.user;
    _familyStream = FamilyService().getFamily(_currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Family Settings'),
        ),
        drawer: MyMenuBar(user: _currentUser),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => EditChildPage(),
              // ));
            },
            child: const Icon(Icons.add)
        ),
        body: StreamBuilder(
            stream: _familyStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.data.docs.length == 0) {
                return const Text("Error: You have no family");
              }

              var family = Family.fromSnapshot(snapshot.data.docs[0].id, snapshot.data.docs[0].data());

              return ListView.builder(
                itemCount: family.children.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return familyName(family.name);
                  } else {
                    var child = family.children[index - 1];
                    return childCard(child, context);
                  }
                },
              );
            }));
  }

  Widget familyName(String name) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 38.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget childCard(Child child, BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(children: [
                  Center(
                    child: Text(
                      child.name,
                      style: const TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EditChildPage(child),
                        ));
                      },
                    ),
                  ),
                ]),
              ),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Age: ${child.age}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Balance: \$${child.balance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.green),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
