import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rahener/core/models/auth_type.dart';

class PhoneAuthScreen extends StatefulWidget {
  final AuthType _type;
  final Function _onSubmit;
  const PhoneAuthScreen(
      {super.key, required AuthType type, required Function onSubmit})
      : _type = type,
        _onSubmit = onSubmit;

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          InternationalPhoneNumberInput(onInputChanged: null),
          ElevatedButton(
              onPressed: () => widget._onSubmit,
              child: const Text("Send verification code"))
        ],
      ),
    );
  }
}
