import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../model/child.dart';
import '../fire_auth.dart';
import '../service/family_service.dart';
import '../validator.dart';
import 'profile_page.dart';

class EditChildPage extends StatefulWidget {
  final Child child;

  EditChildPage(this.child);

  @override
  _EditChildPageState createState() => _EditChildPageState();
}

class _EditChildPageState extends State<EditChildPage> {
  final _editChildFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameTextController;
  late final TextEditingController _ageTextController;
  final _familyService = FamilyService();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();

  bool _isProcessing = false;


  @override
  void initState() {
    _nameTextController = TextEditingController(text: widget.child.name);
    _ageTextController = TextEditingController(text: widget.child.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Child'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _editChildFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _ageTextController,
                        focusNode: _focusEmail,
                        keyboardType: TextInputType.number,
                        validator: (value) => Validator.validateAge(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Age",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      if (_editChildFormKey.currentState!.validate()) {
                                        final newChild = widget.child
                                            .withName(_nameTextController.text)
                                            .withAge(int.parse(_ageTextController.text));
                                        await _familyService.editChildInfo(newChild);

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        Navigator.pop(context, newChild);
                                      } else {
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
