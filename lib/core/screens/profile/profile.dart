import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rahener/core/blocs/user_cubit.dart';
import 'package:rahener/core/blocs/user_state.dart';

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

  Widget _unLoggedUserProfile() {
    return Column(children: [
      Text("Already have an account?"),
      // _loginButton(),
      // _registerButton()
    ]);
  }

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
    bloc.Future.delayed(const Duration(milliseconds: 5000), () {
      bloc.signout();
    });
    return Scaffold(
        appBar: AppBar(
            // title: const Text('Profile'),
            ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.notLogged) {
              return Text("loggooooo desu neeeeeee");
            }
            if (state.status == UserStatus.logged) {
              return Text("not logged dawg");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
