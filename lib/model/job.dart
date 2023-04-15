import 'package:cloud_firestore/cloud_firestore.dart';

import 'child.dart';

class Job {
  final String id;
  final String familyUid;
  final String name;
  final String description;
  final double payment;
  final String status;

  Job(this.id, this.familyUid, this.name, this.description, this.payment, this.status);

  factory Job.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    return Job(id, snapshot['familyUid'], snapshot['name'], snapshot['description'], snapshot['payment'].toDouble(), snapshot['status']);
  }
}
