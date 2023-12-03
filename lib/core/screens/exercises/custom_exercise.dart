import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/exercise_list_cubit.dart';
import 'package:rahener/core/blocs/exercise_list_state.dart';
import 'package:rahener/core/models/exercise.dart';
import 'package:rahener/utils/constants.dart';

class CustomExercise extends StatefulWidget {
  const CustomExercise({super.key});

  @override
  State<CustomExercise> createState() => _CustomExerciseState();
}

class _CustomExerciseState extends State<CustomExercise> {
  final _stepsRightmargin = 50.0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _exerciseNameController = TextEditingController();
  final List<TextEditingController> _exerciseStepsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _exerciseTipsControllers = [
    TextEditingController()
  ];
  String _selectedEquipment = "";
  String _selectedPrimaryMuscle = "";
  final List<String> _musclesTargeted = [];

  Widget _nameField() {
    return TextFormField(
      maxLength: 40,
      controller: _exerciseNameController,
      decoration: const InputDecoration(
          counterText: '', labelText: "Exercise Name", filled: true),
      validator: (value) {
        if (value == "") {
          return 'Please enter a name for the exercise';
        }
        return null;
      },
    );
  }

  Widget _stepsList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: Constants.margin4),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Container(
          height: Constants.margin3,
        );
      },
      itemCount: _exerciseStepsControllers.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _exerciseStepsControllers[index],
                decoration: InputDecoration(
                    hintText: 'Step ${index + 1}', filled: true),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter exercise step ${index + 1}';
                  }
                  return null;
                },
              ),
            ),
            _exerciseStepsControllers.length < 2
                ? Container(
                    width: _stepsRightmargin,
                  )
                : IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        _exerciseStepsControllers.removeAt(index);
                      });
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _addStepButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(350, 40),
      ),
      onPressed: _exerciseStepsControllers.length > 14
          ? null
          : () {
              setState(() {
                _exerciseStepsControllers.add(TextEditingController());
              });
            },
      child: const Text(
        '+',
        style: TextStyle(fontSize: Constants.fontSize5),
      ),
    );
  }

  Widget _tipsList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: Constants.margin4),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Container(
          height: Constants.margin3,
        );
      },
      itemCount: _exerciseTipsControllers.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _exerciseTipsControllers[index],
                decoration:
                    InputDecoration(hintText: 'Tip ${index + 1}', filled: true),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter exercise tip ${index + 1}';
                  }
                  return null;
                },
              ),
            ),
            _exerciseTipsControllers.length < 2
                ? Container(
                    width: _stepsRightmargin,
                  )
                : IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        _exerciseTipsControllers.removeAt(index);
                      });
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _addTipButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(350, 40), // NEW
      ),
      onPressed: _exerciseTipsControllers.length > 14
          ? null
          : () {
              setState(() {
                _exerciseTipsControllers.add(TextEditingController());
              });
            },
      child: const Text(
        '+',
        style: TextStyle(fontSize: Constants.fontSize5),
      ),
    );
  }

  Widget _equipmentDropDown(ExerciseListState state) {
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please select an equipment for the exercise';
          }
          return null;
        },
        hint: const Text("Select Equipment"),
        value: _selectedEquipment == "" ? null : _selectedEquipment,
        items: List.generate(state.equipmentNames.length, (index) {
          return DropdownMenuItem(
              value: state.equipmentNames[index],
              child: Text(state.equipmentNames[index]));
        }),
        onChanged: _onEquipmentSelected);
  }

  Widget _primaryMuscleDropDown(ExerciseListState state) {
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please select a primary muscle for the exercise';
          }
          return null;
        },
        hint: const Text("Select Muscle"),
        value: _selectedPrimaryMuscle == "" ? null : _selectedPrimaryMuscle,
        items: List.generate(state.primaryMuscleGroupNames.length, (index) {
          return DropdownMenuItem(
              value: state.primaryMuscleGroupNames[index],
              child: Text(state.primaryMuscleGroupNames[index]));
        }),
        onChanged: _onPrimaryMuscleSelected);
  }

  Widget _muscleGroupChips(state) {
    return FormField(
        enabled: true,
        validator: ((_) {
          if (_musclesTargeted.isEmpty) {
            return "Please select atleast one muscle group";
          }
          return null;
        }),
        builder: ((FormFieldState fstate) {
          return Column(
            children: [
              fstate.hasError
                  ? Text(
                      fstate.errorText!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    )
                  : Container(),
              Wrap(
                spacing: Constants.chipSpacing,
                runSpacing: Constants.chipRunSpacing,
                children: List.generate(state.primaryMuscleGroupNames.length,
                    (index) {
                  String name = state.primaryMuscleGroupNames[index];
                  bool isSelected = _musclesTargeted.contains(name);
                  return InputChip(
                      label: Text(name),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _musclesTargeted.add(name);
                          } else {
                            _musclesTargeted.remove(name);
                          }
                        });
                      });
                }),
              ),
            ],
          );
        }));
  }

  Widget _saveButton(bloc) {
    return FloatingActionButton.extended(
        heroTag: "custom exercise",
        label: const Text("Save"),
        icon: Icon(Icons.save), // Save icon
        onPressed: () => _onSaveButtonTapped(bloc));
  }

  void _onSaveButtonTapped(bloc) {
    if (_formKey.currentState!.validate()) {
      List<String> exerciseSteps = _exerciseStepsControllers
          .map((controller) => controller.text)
          .toList();
      List<String> exerciseTips = _exerciseTipsControllers
          .map((controller) => controller.text)
          .toList();

      String id = Exercise.generateUniqueKey();

      Exercise newExercise = Exercise(
          id: id,
          name: _exerciseNameController.text,
          equipment: _selectedEquipment,
          primaryMuscle: _selectedPrimaryMuscle,
          secondaryMuscles: _musclesTargeted,
          tips: exerciseTips,
          steps: exerciseSteps,
          similarExercises: []);

      bloc.onSaveExerciseButtonTapped(newExercise);
      Navigator.pop(context);
    }
  }

  void _onEquipmentSelected(item) {
    _selectedEquipment = item;
    log("pressed");
  }

  void _onPrimaryMuscleSelected(item) {
    _selectedPrimaryMuscle = item;
    log("pressed");
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ExerciseListCubit>(context);
    var state = bloc.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Exercise'),
      ),
      floatingActionButton: _saveButton(bloc),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.only(
          left: Constants.sideMargin,
          right: Constants.sideMargin,
          top: Constants.sideMargin,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: Constants.margin3),
              _nameField(),
              const SizedBox(height: Constants.margin7),
              Text(
                'Steps:',
                style: TextStyle(
                    fontSize: Constants.fontSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: Constants.margin3),
              _stepsList(),
              _addStepButton(),
              const SizedBox(height: Constants.margin7),
              Text(
                'Tips:',
                style: TextStyle(
                    fontSize: Constants.fontSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: Constants.margin3),
              _tipsList(),
              _addTipButton(),
              const SizedBox(height: Constants.margin7),
              Text(
                'Primary Muscle:',
                style: TextStyle(
                    fontSize: Constants.fontSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              _primaryMuscleDropDown(state),
              const SizedBox(height: Constants.margin7),
              Text(
                'Equipment:',
                style: TextStyle(
                    fontSize: Constants.fontSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: Constants.margin3),
              _equipmentDropDown(state),
              const SizedBox(height: Constants.margin9),
              Text(
                'Muscles Targeted:',
                style: TextStyle(
                    fontSize: Constants.fontSize4,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: Constants.margin3),
              _muscleGroupChips(state),
              const SizedBox(height: Constants.margin11),
              const SizedBox(height: Constants.margin7),
            ],
          ),
        ),
      )),
    );
  }
}
