import 'package:flutter/material.dart';
import 'package:rahener/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (value) {
        // bloc.
      },
      items: [
        BottomNavigationBarItem(
            label: "asdfdf",
            // label: AppLocalizations.of(context)!.ExercisesNavItem,
            icon: Icon(Constants.exercisesListIcon)),
        BottomNavigationBarItem(
            label: "adfadsf",
            // label: AppLocalizations.of(context)!.ProfileNavItem,
            icon: Icon(Constants.profileIcon)),
      ],
    );
  }
}
