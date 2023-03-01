import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/navigation_cubit.dart';
import 'package:rahener/core/blocs/navigation_state.dart';
import 'package:rahener/core/screens/exercises_list.dart';
import 'package:rahener/core/screens/profile.dart';
import 'package:rahener/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<NavigationCubit>(context);
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: const [ExercisesListScreen(), ProfileScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              return bloc.onNavItemTapped(context, index);
            },
            items: [
              BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.exercisesNavItem,
                  icon: const Icon(Constants.exercisesListIcon)),
              BottomNavigationBarItem(
                  label: AppLocalizations.of(context)!.profileNavItem,
                  icon: const Icon(Constants.profileIcon)),
            ],
          ),
        );
      },
    );
  }
}
