import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class RoleRouterPage extends StatelessWidget {
  const RoleRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('RoleRouterPage: State changed to $state');
        if (state is AuthAuthenticated) {
          print('RoleRouterPage: User role = ${state.user.role}');
          if (state.user.role == 'student') {
            print('Navigating to student dashboard');
            context.go('/student/dashboard');
          } else if (state.user.role == 'lecturer') {
            print('Navigating to lecturer dashboard');
            context.go('/lecturer/dashboard');
          } else if (state.user.role == 'admin') {
            print('Navigating to admin audit');
            context.go('/admin/audit');
          }
        } else if (state is AuthUnauthenticated) {
          print('RoleRouterPage: Unauthenticated, going to login');
          context.go('/login');
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
