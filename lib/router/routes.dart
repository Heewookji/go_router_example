import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/constants.dart';
import 'package:navigation/login_state.dart';
import 'package:navigation/ui/create_account.dart';
import 'package:navigation/ui/error_page.dart';
import 'package:navigation/ui/login.dart';

class MyRouter {
  final LoginState loginState;

  MyRouter(this.loginState);

  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        redirect: (context, state) =>
            // TODO: Change to Home Route
            GoRouter.of(context).namedLocation(loginRouteName),
      ),
      GoRoute(
        name: loginRouteName,
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Login(),
        ),
      ),
      GoRoute(
        name: createAccountRouteName,
        path: '/create-account',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const CreateAccount(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
    redirect: null,
  );
}
