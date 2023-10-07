import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneNumVerification extends StatefulWidget {
  const PhoneNumVerification({super.key});

  @override
  State<PhoneNumVerification> createState() => _PhoneNumVerificationState();
}

class _PhoneNumVerificationState extends State<PhoneNumVerification> {
  @override
  Widget build(BuildContext context) {
    // must have a timer
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [PinCodeTextField(appContext: context, length: 6)],
      ),
    );
  }
}
