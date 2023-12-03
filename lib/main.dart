import 'dart:developer';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rahener/core/blocs/exercise_list_cubit.dart';
import 'package:rahener/core/blocs/exercise_progress_cubit.dart';
import 'package:rahener/core/blocs/measurements_cubit.dart';
import 'package:rahener/core/blocs/navigation_cubit.dart';
import 'package:rahener/core/blocs/current_session_cubit.dart';
import 'package:rahener/core/blocs/session_timer_cubit.dart';
import 'package:rahener/core/blocs/sessions_cubit.dart';
import 'package:rahener/core/blocs/user_cubit.dart';
import 'package:rahener/core/repositories/measurement_repository.dart';
import 'package:rahener/core/repositories/sessions_repository.dart';
import 'package:rahener/core/services/firebase_auth_service.dart';
import 'package:rahener/core/repositories/exercises_repository.dart';
import 'package:rahener/core/services/firestore_data.dart';
import 'package:rahener/core/services/hive_data.dart';
import 'package:rahener/core/services/local_data.dart';
import 'package:rahener/main_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Locale locale = const Locale('en');

  // Data services
  LocalDataService localDataService =
      await LocalDataService.create(locale.languageCode);
  HiveDataService hiveDataService = await HiveDataService.create();
  FirestoreService firestoreService =
      FirestoreService(instance: FirebaseFirestore.instance);
  FireBaseAuthService authService = FireBaseAuthService(FirebaseAuth.instance);

  // repositories
  SessionsRepository sessionsRepository =
      await SessionsRepository.create(localDataService: localDataService);
  ExercisesRepository exercisesRepository = await ExercisesRepository.create(
      localDataService: localDataService,
      hiveDataService: hiveDataService,
      fireStoreService: firestoreService,
      fireBaseAuthService: authService);
  MeasurementsRepository measurementsRepository =
      await MeasurementsRepository.create(localDataService: localDataService);

  runApp(MyApp(
    locale: locale,
    exercisesRepository: exercisesRepository,
    authService: authService,
    firestoreService: firestoreService,
    sessionsRepository: sessionsRepository,
    measurementsRepository: measurementsRepository,
  ));
}

class MyApp extends StatelessWidget {
  final Locale _locale;
  final ExercisesRepository exercisesRepository;
  final SessionsRepository sessionsRepository;
  final MeasurementsRepository measurementsRepository;
  final FireBaseAuthService authService;
  final FirestoreService firestoreService;

  const MyApp(
      {super.key,
      required this.exercisesRepository,
      required this.firestoreService,
      required Locale locale,
      required this.authService,
      required this.sessionsRepository,
      required this.measurementsRepository})
      : _locale = locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rahêner',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xFF006877)),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => exercisesRepository),
          RepositoryProvider(create: (context) => authService),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ExerciseListCubit>(
              create: (context) => ExerciseListCubit(
                  exercisesRepository: context.read<ExercisesRepository>()),
            ),
            BlocProvider<CurrentSessionCubit>(
              create: (context) =>
                  CurrentSessionCubit(repository: exercisesRepository),
            ),
            BlocProvider<ExerciseProgressCubit>(
              create: (context) => ExerciseProgressCubit(sessionsRepository),
            ),
            BlocProvider<SessionTimerCubit>(
              create: (context) => SessionTimerCubit(),
            ),
            BlocProvider<SessionsCubit>(
              create: (context) => SessionsCubit(sessionsRepository),
            ),
            BlocProvider<MeasurementsCubit>(
              create: (context) =>
                  MeasurementsCubit(repository: measurementsRepository),
            ),
            BlocProvider<NavigationCubit>(
              create: (context) => NavigationCubit(startingIndex: 0),
            ),
            BlocProvider<UserCubit>(
              create: (context) => UserCubit(
                  authService: context.read<FireBaseAuthService>(),
                  firestoreService: firestoreService),
            ),
          ],
          child: const MainLayout(),
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
