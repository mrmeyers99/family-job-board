class Child {
  final String familyUid;
  final String uid;
  final String name;
  final int age;
  final double balance;

  Child(this.familyUid, this.uid, this.name, this.age, this.balance);

  factory Child.fromSnapshot(String familyUid, String childUid, Map<String, dynamic> snapshot) {
    return Child(familyUid, childUid, snapshot['name'], snapshot['age'], snapshot['balance'].toDouble());
  }

  Child withName(String name) {
    return Child(familyUid, uid, name, age, balance);
  }

  Child withAge(int age) {
    return Child(familyUid, uid, name, age, balance);
  }
}
