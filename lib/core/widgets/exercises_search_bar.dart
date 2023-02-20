import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/ExerciseListState.dart';
import 'package:rahener/core/blocs/filter_cubit.dart';
import '../../utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExerciseSearchBar extends StatefulWidget {
  final Widget filterDialog;
  const ExerciseSearchBar({super.key, required this.filterDialog});
  @override
  State<ExerciseSearchBar> createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ExerciseListCubit>(context);
    return BlocBuilder<ExerciseListCubit, ExerciseListState>(
      builder: (context, state) {
        return SliverAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                  controller: bloc.state.searchFieldController,
                  onChanged: (value) => bloc.onSearchFiledChanged(value),
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchFieldHint,
                      prefixIcon: const Icon(Constants.searchBarPrefixIcon),
                      suffixIcon: bloc.shouldShowCancelIcon()
                          ? IconButton(
                              icon: const Icon(Constants.cancelSearchIcon),
                              onPressed: bloc.onCancelQueryTapped,
                            )
                          : null,
                      constraints: const BoxConstraints(maxWidth: 300))),
              IconButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (_) => Dialog.fullscreen(
                    child: BlocProvider.value(
                      value: bloc,
                      child: widget.filterDialog,
                    ),
                  ),
                ),
                color: ThemeData().primaryColor,
                icon: const Icon(Constants.filterIcon),
              )
            ],
          ),
          pinned: false,
          floating: true,
          snap: false,
        );
      },
    );
  }
}
