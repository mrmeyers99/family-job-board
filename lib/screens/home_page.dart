import 'package:family_job_board/AppConstants.dart';
import 'package:family_job_board/service/job_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../model/family.dart';
import '../model/job.dart';
import '../widgets/menu_bar.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late User _currentUser;
  late Stream _jobStream;

  final _log = Logger('_HomePageState');

  @override
  void initState() {
    _currentUser = widget.user;
    _jobStream = JobService().getAvailableJobs(_currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Job Board'),
        ),
        drawer: MyMenuBar(user: _currentUser),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => EditChildPage(Child.blank(_currentUser.uid)),
              // ));
            },
            child: const Icon(Icons.add)
        ),
        body: StreamBuilder(
            stream: _jobStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.data.docs.length == 0) {
                return const Text("Tell your parents to add some jobs to the board!");
              }

              final jobs = snapshot.data.docs.map((doc) => Job.fromSnapshot(doc.id, doc.data())).toList();
              return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return jobCard(jobs[index], context);
                },
              );
            }));
  }

  Widget jobCard(Job job, BuildContext context) {
    return GestureDetector(onTap: () {
      _log.info("Tapped on the the card");
    },
        child: Card(
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
                      job.name,
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
                        _log.info("Tapped on the edit button");
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => EditChildPage(job),
                        // ));
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
                job.description,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Pays: \$${job.payment.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.green),
              ),
            ),
          ]),
        ],
      ),
    ));
  }
}
