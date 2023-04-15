import 'package:uuid/uuid.dart';

class Child {
  final String familyUid;
  final String uid;
  final String name;
  final int age;
  final double balance;

  Child(this.familyUid, this.uid, this.name, this.age, this.balance);

  factory Child.fromSnapshot(String familyUid, String childUid, Map<String, dynamic> snapshot) {
    return Child(familyUid, childUid, snapshot['name'], snapshot['age'], snapshot['balance'] == null ? 0 : snapshot['balance'].toDouble());
  }



  factory Child.blank(String familyUid) {
    return Child(familyUid, const Uuid().v4(), "", 0, 0.0);
  }

  Child withName(String name) {
    return Child(familyUid, uid, name, age, balance);
  }

  Child withAge(int age) {
    return Child(familyUid, uid, name, age, balance);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'balance': balance,
    };
  }
}
