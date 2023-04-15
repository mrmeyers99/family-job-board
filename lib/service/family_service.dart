import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import '../model/child.dart';
import '../model/family.dart';


class FamilyService {
  final _log = Logger('FamilyService');
  final CollectionReference _families;

  FamilyService()
      : _families = FirebaseFirestore.instance.collection("families");

  Stream<QuerySnapshot> getFamily(String userUid) {
    _log.info("Querying families for family ${userUid}");
    return _families.where("ownerUid", isEqualTo: userUid).snapshots();
  }
  // DocumentReference<Family> getFamily(String userUid) {
  //   _log.info("Querying families for family ${userUid}");
    // return _families.doc(userUid)
    //     .withConverter(
    //       fromFirestore: (snapshot, _) => Family.fromSnapshot(userUid, snapshot.data()!),
    //       toFirestore: (family, _) => family.toJson());
  // }

  Future<void> editChildInfo(Child child) {
    return _families.doc(child.familyUid).update({
      "children.${child.uid}.name": child.name,
      "children.${child.uid}.age": child.age,
    });
  }
}
