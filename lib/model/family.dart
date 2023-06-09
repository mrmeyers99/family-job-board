import 'package:cloud_firestore/cloud_firestore.dart';

import 'child.dart';

class Family {
  final String id;
  final String name;
  final List<Child> children;

  Family(this.id, this.name, this.children);

  factory Family.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    final children = snapshot['children'].keys.map<Child>((e) => Child.fromSnapshot(id, e, snapshot['children'][e])).toList();
    return Family(id, snapshot['name'], children);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'children': { for (var c in children) c.uid : c.toJson() },
    };
  }
}
