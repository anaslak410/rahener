import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rahener/core/blocs/user_cubit.dart';
import 'package:rahener/core/blocs/user_state.dart';
import 'package:rahener/core/models/auth_type.dart';
import 'package:rahener/core/screens/profile/phone_auth.dart';
import 'package:rahener/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Widget _loginText();

  // tell user why this is important

  // Widget _loginText();
  // Widget _loginButton();

  // Widget _registerText();
  // Widget _registerButton();

  Widget _loggedInProfile() {
    return Row(
      children: [],
    );
  }

  Widget _unLoggedProfile(UserCubit bloc) {
    return Container(
      padding: const EdgeInsets.only(
          left: Constants.sideMargin, right: Constants.sideMargin),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'To be backup and restore your data, create an account or login\n',
            style: TextStyle(fontSize: Constants.fontSize5),
            textAlign: TextAlign.center,
          ),
          const Text(
            'an sms code will be sent to the number you provide below confirm your identity',
            style: TextStyle(fontSize: Constants.fontSize3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          InternationalPhoneNumberInput(
            maxLength: 12,
            initialValue: PhoneNumber(isoCode: 'IQ'),
            onInputChanged: null,
            selectorConfig: const SelectorConfig(
                leadingPadding: 1, selectorType: PhoneInputSelectorType.DIALOG),
            // selectorTextStyle: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => _onSignUpButtonTapped(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                ),
                child: const Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () => _onLoginButtonTapped(bloc),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  minimumSize: const Size(150, 50),
                ),
                child: Text('Log In'),
              ),
            ],
          ),
        ],
      )),
    );
  }

  void _onLoginButtonTapped(UserCubit bloc) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => PhoneAuthScreen(
    //           type: AuthType.login,
    //           onSubmit: bloc.sendSms,
    //         )));
    //   void _showPhoneNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your phone number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InternationalPhoneNumberInput(
                maxLength: 10,
                initialValue: PhoneNumber(isoCode: 'IQ'),
                onInputChanged: null,

                selectorConfig: SelectorConfig(
                    leadingPadding: 1,
                    selectorType: PhoneInputSelectorType.DIALOG),
                // selectorTextStyle: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Send SMS'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSignUpButtonTapped() {}

  @override
  void dispose() {
    var bloc = BlocProvider.of<UserCubit>(context);
    if (bloc.state.status != UserStatus.logged) {
      bloc.abortAuthentication();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<UserCubit>(context);
    // Future.delayed(const Duration(milliseconds: 5000), () {
    // bloc.signout();
    // });
    return Scaffold(
        // maybe we will have a coupe
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.notLogged) {
              return _loggedInProfile();
            }
            if (state.status == UserStatus.logged) {
              return _unLoggedProfile(bloc);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
