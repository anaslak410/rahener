import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rahener/core/blocs/filter_cubit.dart';
import 'package:rahener/core/repositories/exercises_repository.dart';
import 'package:rahener/core/screens/exercises_list.dart';
import 'package:rahener/core/services/local_json_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Data services
  LocalJsonDataService localJsonDataService =
      await LocalJsonDataService.create();

  // repositories
  ExercisesRepository exercisesRepository = await ExercisesRepository.create(
      localJsonDataService: localJsonDataService);

  runApp(MyApp(
    exercisesRepository: exercisesRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.exercisesRepository});
  final ExercisesRepository exercisesRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rahêner',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xFF006877)),
      home: RepositoryProvider(
        create: (context) => exercisesRepository,
        child: BlocProvider(
          create: (context) => ExerciseListCubit(
              exercisesRepository: context.read<ExercisesRepository>()),
          child: const ExercisesListScreen(),
        ),
      ),
    );
  }
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006877),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFA3EEFF),
  onPrimaryContainer: Color(0xFF001F25),
  secondary: Color(0xFF4A6268),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCDE7ED),
  onSecondaryContainer: Color(0xFF051F24),
  tertiary: Color(0xFF006C51),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF83F8CD),
  onTertiaryContainer: Color(0xFF002116),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFCFD),
  onBackground: Color(0xFF191C1D),
  surface: Color(0xFFFBFCFD),
  onSurface: Color(0xFF191C1D),
  surfaceVariant: Color(0xFFDBE4E7),
  onSurfaceVariant: Color(0xFF3F484A),
  outline: Color(0xFF6F797B),
  onInverseSurface: Color(0xFFEFF1F2),
  inverseSurface: Color(0xFF2E3132),
  inversePrimary: Color(0xFF52D7EF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006877),
  outlineVariant: Color(0xFFBFC8CB),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF52D7EF),
  onPrimary: Color(0xFF00363E),
  primaryContainer: Color(0xFF004E5A),
  onPrimaryContainer: Color(0xFFA3EEFF),
  secondary: Color(0xFFB1CBD1),
  onSecondary: Color(0xFF1C3439),
  secondaryContainer: Color(0xFF334A50),
  onSecondaryContainer: Color(0xFFCDE7ED),
  tertiary: Color(0xFF66DBB2),
  onTertiary: Color(0xFF003829),
  tertiaryContainer: Color(0xFF00513C),
  onTertiaryContainer: Color(0xFF83F8CD),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1D),
  onBackground: Color(0xFFE1E3E3),
  surface: Color(0xFF191C1D),
  onSurface: Color(0xFFE1E3E3),
  surfaceVariant: Color(0xFF3F484A),
  onSurfaceVariant: Color(0xFFBFC8CB),
  outline: Color(0xFF899295),
  onInverseSurface: Color(0xFF191C1D),
  inverseSurface: Color(0xFFE1E3E3),
  inversePrimary: Color(0xFF006877),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF52D7EF),
  outlineVariant: Color(0xFF3F484A),
  scrim: Color(0xFF000000),
);
