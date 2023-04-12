import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluxus2/app/feature/graduation/select/graduation_select_page.dart';

import 'core/authentication/authentication.dart';
import 'core/models/user_model.dart';
import 'core/repositories/user_repository.dart';
import 'data/b4a/table/user_b4a.dart';
import 'feature/expertise/list/expertise_list_page.dart';
import 'feature/expertise/save/expertise_save_page.dart';
import 'feature/expertise/select/expertise_select_page.dart';
import 'feature/graduation/list/graduation_list_page.dart';
import 'feature/graduation/save/graduation_save_page.dart';
import 'feature/home/home_page.dart';
import 'feature/procedure/save/procedure_save_page.dart';
import 'feature/procedure/search/procedure_search_page.dart';
import 'feature/procedure/select/procedure_select_page.dart';
import 'feature/splash/splash_page.dart';
import 'feature/user/login/login_page.dart';
import 'feature/user/register/email/user_register_email.page.dart';
import 'feature/userprofile/save/user_profile_save_page.dart';
import 'feature/userprofile/search/user_profile_search_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository(userB4a: UserB4a());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          userRepository: _userRepository,
        )..add(AuthenticationEventInitial()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(), (route) => false);
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(), (route) => false);
            } else {
              return;
            }
          },
          child: child,
        );
      },
      routes: {
        '/': (_) => const SplashPage(),
        '/register/email': (_) => const UserRegisterEmailPage(),
        '/userProfile/edit': (context) {
          UserModel user =
              ModalRoute.of(context)!.settings.arguments as UserModel;

          return UserProfileSavePage(
            userModel: user,
          );
        },
        '/userProfile/search': (_) => const UserProfileSearchPage(),
        '/graduation/list': (_) => const GraduationListPage(),
        '/graduation/save': (_) => const GraduationSavePage(),
        '/graduation/select': (_) => const GraduationSelectPage(),
        '/expertise/list': (_) => const ExpertiseListPage(),
        '/expertise/save': (_) => const ExpertiseSavePage(),
        '/expertise/select': (_) => const ExpertiseSelectPage(),
        '/procedure/save': (_) => const ProcedureSavePage(),
        '/procedure/search': (_) => const ProcedureSearchPage(),
        '/procedure/select': (_) => const ProcedureSelectPage(),
      },
      initialRoute: '/',
    );
  }
}
