import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import '../model/child.dart';
import '../model/family.dart';


class JobService {
  final _log = Logger('JobService');
  final CollectionReference _jobs;

  JobService()
      : _jobs = FirebaseFirestore.instance.collection("jobs");

  Stream<QuerySnapshot> getAvailableJobs(String familyUid) {
    _log.info("Querying jobs for family ${familyUid}");
    return _jobs
        .where("familyUid", isEqualTo: familyUid)
        .where('status', isEqualTo: 'available')
        .snapshots();
  }

  // Future<void> editChildInfo(Child child) {
  //   return _families.doc(child.familyUid).update({
  //     "children.${child.uid}.name": child.name,
  //     "children.${child.uid}.age": child.age,
  //   });
  // }
}
