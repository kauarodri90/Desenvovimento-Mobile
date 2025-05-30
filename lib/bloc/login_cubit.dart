import 'package:flutter_bloc/flutter_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final bool isValid;

  LoginState({
    required this.email,
    required this.password,
    required this.isValid,
  });

  factory LoginState.initial() => LoginState(email: '', password: '', isValid: false);

  LoginState copyWith({String? email, String? password, bool? isValid}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  void updateEmail(String email) {
    final newState = state.copyWith(email: email);
    _validateForm(newState);
  }

  void updatePassword(String password) {
    final newState = state.copyWith(password: password);
    _validateForm(newState);
  }

  void _validateForm(LoginState newState) {
    final isValid = newState.email.contains('@') && newState.password.length >= 6;
    emit(newState.copyWith(isValid: isValid));
  }

  void submit() {

    print('E-mail: ${state.email}, Senha: ${state.password}');
  }
}
