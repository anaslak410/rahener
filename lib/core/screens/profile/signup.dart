import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onCreateProfileButtonTapped() {
    // final newUsername = usernameController.text;
    // final newWeight =
    //     double.tryParse(weightController.text) ?? widget.weight;
    // widget.onUpdate(newUsername, newWeight);
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  // double weight = double (value);
                  // if () {

                  // }
                },
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _onCreateProfileButtonTapped(),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
