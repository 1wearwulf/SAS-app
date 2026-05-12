import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dartz/dartz.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'core/ux/splash_screen.dart';
import 'core/shell/student_shell.dart';
import 'core/shell/lecturer_shell.dart';
import 'core/shell/admin_shell.dart';
import 'core/error/failures.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/role_router_page.dart';
import 'features/student/dashboard/presentation/pages/student_dashboard_page.dart';
import 'features/lecturer/session/presentation/pages/lecturer_dashboard_page.dart';
import 'features/admin/audit/presentation/pages/admin_audit_page.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'features/auth/domain/entities/auth_user.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      name: 'role_router',
      builder: (context, state) => const RoleRouterPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => StudentShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.studentDashboard,
          name: 'student_dashboard',
          builder: (context, state) => const StudentDashboardPage(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => LecturerShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.lecturerDashboard,
          name: 'lecturer_dashboard',
          builder: (context, state) => const LecturerDashboardPage(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.adminAudit,
          name: 'admin_audit',
          builder: (context, state) => const AdminAuditPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final mockAuthRepo = MockAuthRepository();
            final signInUseCase = SignInUseCase(mockAuthRepo);
            final signOutUseCase = SignOutUseCase(mockAuthRepo);
            final watchAuthStateUseCase = WatchAuthStateUseCase(mockAuthRepo);
            
            return AuthBloc(
              signInUseCase: signInUseCase,
              signOutUseCase: signOutUseCase,
              watchAuthStateUseCase: watchAuthStateUseCase,
            );
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Smart Attendance System',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, AuthUser>> signIn(String email, String password) async {
    // Demo login - accept any credentials
    return Right(AuthUser(
      id: 'demo_001',
      email: email,
      name: email.split('@').first,
      role: 'student',
    ));
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }
  
  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    return const Right(null);
  }
  
  @override
  Stream<AuthUser?> watchAuthState() async* {
    yield null;
  }
}
