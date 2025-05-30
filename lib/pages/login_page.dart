import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_cubit.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: cubit.updateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: !state.email.contains('@') && state.email.isNotEmpty
                          ? 'E-mail inválido'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    onChanged: cubit.updatePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      errorText: state.password.length < 6 && state.password.isNotEmpty
                          ? 'Senha deve ter no mínimo 6 caracteres'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isValid
                        ? () {
                            cubit.submit();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login realizado com sucesso'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Entrar'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
