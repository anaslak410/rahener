import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rahener/core/blocs/user_cubit.dart';
import 'package:rahener/core/blocs/user_state.dart';
import 'package:rahener/core/models/auth_exception.dart';
import 'package:rahener/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _inputIsValid = false;
  final TextEditingController _phoneNumController = TextEditingController();
  late final UserCubit _bloc;

  Widget _loggedInProfile() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        ListTile(
          title: Text(
            'Username',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _bloc.state.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Divider(), // Add a divider for visual separation
        ListTile(
          title: Text(
            'Body Weight',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'bodyWeight kg',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          trailing: ElevatedButton(
            onPressed: () {
              _bloc.signout();
            },
            child: Text('Sign Out'),
          ),
        ),
      ],
    );
  }

  Widget _unLoggedProfile() {
    return Container(
      padding: const EdgeInsets.only(
          left: Constants.sideMargin, right: Constants.sideMargin),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'To be backup and restore your data, verify your phone number\n',
            style: TextStyle(fontSize: Constants.fontSize5),
            textAlign: TextAlign.center,
          ),
          const Text(
            'an sms code will be sent to the number you provide below to confirm your identity',
            style: TextStyle(fontSize: Constants.fontSize3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildPhoneNumberInput(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSendSMSbutton(),
            ],
          ),
        ],
      )),
    );
  }

  ElevatedButton _buildSendSMSbutton() {
    return ElevatedButton(
      onPressed: _inputIsValid ? () => _onSendSMSbuttonTapped() : null,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        minimumSize: const Size(150, 50),
      ),
      child: const Text('Send SMS Code'),
    );
  }

  InternationalPhoneNumberInput _buildPhoneNumberInput() {
    return InternationalPhoneNumberInput(
      ignoreBlank: true,
      formatInput: true,
      onInputValidated: ((value) {
        setState(() {
          _inputIsValid = value;
        });
      }),
      onInputChanged: ((value) {
        // log(value.phoneNumber.toString());
        _phoneNumController.text = value.phoneNumber.toString();
        // log(phoneNumController.value.text);
      }),
      keyboardType: TextInputType.phone,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 13,
      initialValue: PhoneNumber(isoCode: 'IQ'),
      selectorConfig: const SelectorConfig(
          leadingPadding: 1, selectorType: PhoneInputSelectorType.DIALOG),
    );
  }

  SimpleDialog _buildSMScodeDialog(
      BuildContext context, TextEditingController verifSmsController) {
    return SimpleDialog(
      title: const Text(''),
      contentPadding: const EdgeInsets.all(Constants.margin5),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinCodeTextField(
                appContext: context, length: 6, controller: verifSmsController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onVerifySmsButtonTapped(verifSmsController),
              child: const Text('Verify SMS'),
            ),
          ],
        )
      ],
    );
  }

  SnackBar _buildAuthExceptionSnackbar({
    required String message,
    required String description,
    required BuildContext context,
  }) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // Add some spacing
          Text(description),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  void _showChangeWeightDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Body Weight'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'New Body Weight (kg)',
            ),
            onChanged: (value) {
              setState(() {
                // bodyWeight = double.tryParse(value) ?? bodyWeight;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _onSendSMSbuttonTapped() {
    final TextEditingController verifSmsController = TextEditingController();
    _bloc.sendSms(_phoneNumController.text);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildSMScodeDialog(context, verifSmsController);
      },
    );
  }

  void _onVerifySmsButtonTapped(controller) {
    _bloc.verifySms(controller.text);
  }

  void _handleUserExistsException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "User Already Exists",
      description:
          "Registration failed. User already exists in our system. Please log in or use a different email or username for registration.",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleWrongCodeException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "wrong code",
      description: "wrong code dawg",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleTooManyRequestsException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "Too many requests",
      description: "you attempted too many times",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleInvalidPhoneNumberException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "Invalid Phone Number",
      description:
          "Phone number is invalid. The provided phone number is not in the expected format or is otherwise invalid. Please provide a valid phone number for registration.",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleCodeTimeoutException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "Verification Code Expired",
      description:
          "Verification code has expired. The verification code you attempted to use has exceeded its expiration time. Please request a new code for verification.",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleUnknownException() {
    var snackBar = _buildAuthExceptionSnackbar(
      context: context,
      message: "Unknown Error",
      description:
          "An unknown error occurred. We encountered an unexpected issue that is not covered by specific error categories. Please reach out to our support team for further assistance.",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<UserCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    if (_bloc.state.status != UserStatus.logged) {
      _bloc.abortAuthentication();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    // bloc.signout();
    // });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listenWhen: (previous, current) {
            if (current.authException == AuthException.none) {
              return false;
            }
            return true;
          },
          listener: (context, state) {
            _bloc.abortAuthentication();
            switch (state.authException) {
              case AuthException.userExists:
                _handleUserExistsException();
                break;
              case AuthException.codeTimeout:
                _handleCodeTimeoutException();
                break;
              case AuthException.invalidPhoneNumber:
                _handleInvalidPhoneNumberException();
                break;
              case AuthException.tooManyRequests:
                _handleTooManyRequestsException();
                break;
              case AuthException.wrongCode:
                _handleWrongCodeException();
                break;
              case AuthException.unknown:
                _handleUnknownException();
                break;
              case AuthException.noInternetConnection:
              case AuthException.none:
                throw Exception(
                    "Auth exception was handled when there were no exception");
            }
          },
          buildWhen: (previous, current) {
            return previous.status == current.status ? false : true;
          },
          builder: (context, state) {
            if (state.status == UserStatus.notLogged) {
              return _unLoggedProfile();
            }
            if (state.status == UserStatus.logged) {
              return _loggedInProfile();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
