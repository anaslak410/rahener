import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());
}
