import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';


class RecipeService {
  final _log = Logger('RecipeService');
  final CollectionReference _families;

  RecipeService()
      : _families = FirebaseFirestore.instance.collection("families");

  Stream<QuerySnapshot> getFamily(String userUid) {
    _log.info("Querying family for family ${userUid}");
    return _families.where("ownerUid", isEqualTo: userUid).snapshots();
  }

}