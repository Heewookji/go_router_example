import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/constants.dart';
import 'package:navigation/login_state.dart';
import 'package:navigation/ui/create_account.dart';
import 'package:navigation/ui/details.dart';
import 'package:navigation/ui/error_page.dart';
import 'package:navigation/ui/home_screen.dart';
import 'package:navigation/ui/login.dart';
import 'package:navigation/ui/more_info.dart';
import 'package:navigation/ui/payment.dart';
import 'package:navigation/ui/personal_info.dart';
import 'package:navigation/ui/signin_info.dart';

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
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Login(),
        ),
        redirect: (context, state) =>
            state.namedLocation(homeRouteName, params: {'tab': 'cart'}),
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
      GoRoute(
        name: homeRouteName,
        // 1
        path: '/home/:tab(shop|cart|profile)',
        pageBuilder: (context, state) {
          // 2
          final tab = state.params['tab']!;
          return MaterialPage<void>(
            key: state.pageKey,
            // 3
            child: HomeScreen(tab: tab),
          );
        },
        routes: [
          GoRoute(
            name: subDetailsRouteName,
            // 4
            path: 'details/:item',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              // 5
              child: Details(description: state.params['item']!),
            ),
          ),
          GoRoute(
            name: profilePersonalRouteName,
            path: 'personal',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const PersonalInfo(),
            ),
          ),
          GoRoute(
            name: profilePaymentRouteName,
            path: 'payment',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const Payment(),
            ),
          ),
          GoRoute(
            name: profileSigninInfoRouteName,
            path: 'signin-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const SigninInfo(),
            ),
          ),
          GoRoute(
            name: profileMoreInfoRouteName,
            path: 'more-info',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const MoreInfo(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/shop',
        redirect: (context, state) =>
            state.namedLocation(homeRouteName, params: {'tab': 'shop'}),
      ),
      GoRoute(
        path: '/cart',
        redirect: (context, state) =>
            state.namedLocation(homeRouteName, params: {'tab': 'cart'}),
      ),
      GoRoute(
        path: '/profile',
        redirect: (context, state) =>
            state.namedLocation(homeRouteName, params: {'tab': 'profile'}),
      ),
      GoRoute(
        name: detailsRouteName,
        // 2
        path: '/details-redirector/:item',
        // 3
        redirect: (context, state) => state.namedLocation(
          subDetailsRouteName,
          params: {'tab': 'shop', 'item': state.params['item']!},
        ),
      ),
      GoRoute(
        name: personalRouteName,
        path: '/profile-personal',
        redirect: (context, state) => state.namedLocation(
          profilePersonalRouteName,
          // 4
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: paymentRouteName,
        path: '/profile-payment',
        redirect: (context, state) => state.namedLocation(
          profilePaymentRouteName,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: signinInfoRouteName,
        path: '/profile-signin-info',
        redirect: (context, state) => state.namedLocation(
          profileSigninInfoRouteName,
          params: {'tab': 'profile'},
        ),
      ),
      GoRoute(
        name: moreInfoRouteName,
        path: '/profile-more-info',
        redirect: (context, state) => state.namedLocation(
          profileMoreInfoRouteName,
          params: {'tab': 'profile'},
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
    redirect: (_, state) {
      final isLoginLocNow = state.subloc == '/login';
      final isCreatingAccountLocNow = state.subloc == '/create-account';
      final isAuthenticated = loginState.loggedIn;

      if (!isAuthenticated && !isLoginLocNow && !isCreatingAccountLocNow) {
        return '/login';
      }
      if (isAuthenticated && (isLoginLocNow || isCreatingAccountLocNow)) {
        return '/';
      }
      return null;
    },
  );
}
