import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluxus2/app/core/models/healthplan_model.dart';
import 'package:fluxus2/app/feature/graduation/select/graduation_select_page.dart';

import 'core/authentication/authentication.dart';
import 'core/models/expertise_model.dart';
import 'core/models/graduation_model.dart';
import 'core/models/healthplantype_model.dart';
import 'core/models/patient_model.dart';
import 'core/models/procedure_model.dart';
import 'core/models/region_model.dart';
import 'core/models/room_model.dart';
import 'core/models/user_model.dart';
import 'core/models/user_profile_model.dart';
import 'core/repositories/user_repository.dart';
import 'data/b4a/table/user_b4a.dart';
import 'feature/expertise/list/expertise_list_page.dart';
import 'feature/expertise/print/expertise_print_page.dart';
import 'feature/expertise/save/expertise_save_page.dart';
import 'feature/expertise/select/expertise_select_page.dart';
import 'feature/graduation/list/graduation_list_page.dart';
import 'feature/graduation/print/graduation_print_page.dart';
import 'feature/graduation/save/graduation_save_page.dart';
import 'feature/healthplan/save/healthplan_save_page.dart';
import 'feature/healthplantype/list/healthplantype_list_page.dart';
import 'feature/healthplantype/print/healthplantype_print_page.dart';
import 'feature/healthplantype/save/healthplantype_save_page.dart';
import 'feature/healthplantype/select/healthplantype_select_page.dart';
import 'feature/home/home_page.dart';
import 'feature/patient/print/patient_print_page.dart';
import 'feature/patient/save/patient_save_page.dart';
import 'feature/patient/search/patient_search_page.dart';
import 'feature/patient/select/patient_select_page.dart';
import 'feature/procedure/print/procedure_print_page.dart';
import 'feature/procedure/save/procedure_save_page.dart';
import 'feature/procedure/search/procedure_search_page.dart';
import 'feature/procedure/select/procedure_select_page.dart';
import 'feature/region/print/region_print_page.dart';
import 'feature/region/save/region_save_page.dart';
import 'feature/region/search/region_search_page.dart';
import 'feature/region/select/region_select_page.dart';
import 'feature/room/list/room_list_page.dart';
import 'feature/room/print/room_print_page.dart';
import 'feature/room/save/room_save_page.dart';
import 'feature/room/select/room_select_page.dart';
import 'feature/splash/splash_page.dart';
import 'feature/user/login/login_page.dart';
import 'feature/user/register/email/user_register_email.page.dart';
import 'feature/userprofile/print/userprofile_print_page.dart';
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
        '/userProfile/print': (context) {
          List<UserProfileModel>? modelList = ModalRoute.of(context)!
              .settings
              .arguments as List<UserProfileModel>?;
          return UserProfilePrintPage(modelList: modelList ?? []);
        },
        '/graduation/list': (_) => const GraduationListPage(),
        '/graduation/save': (_) => const GraduationSavePage(),
        '/graduation/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return GraduationSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/graduation/print': (context) {
          List<GraduationModel>? modelList = ModalRoute.of(context)!
              .settings
              .arguments as List<GraduationModel>?;
          return GraduationPrintPage(modelList: modelList ?? []);
        },
        '/expertise/list': (_) => const ExpertiseListPage(),
        '/expertise/save': (_) => const ExpertiseSavePage(),
        '/expertise/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return ExpertiseSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/expertise/print': (context) {
          List<ExpertiseModel>? modelList = ModalRoute.of(context)!
              .settings
              .arguments as List<ExpertiseModel>?;
          return ExpertisePrintPage(modelList: modelList ?? []);
        },
        '/procedure/save': (_) => const ProcedureSavePage(),
        '/procedure/search': (_) => const ProcedureSearchPage(),
        '/procedure/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return ProcedureSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/procedure/print': (context) {
          List<ProcedureModel>? modelList = ModalRoute.of(context)!
              .settings
              .arguments as List<ProcedureModel>?;
          return ProcedurePrintPage(modelList: modelList ?? []);
        },
        '/region/save': (_) => const RegionSavePage(),
        '/region/search': (_) => const RegionSearchPage(),
        '/region/select': (_) => const RegionSelectPage(),
        '/region/print': (context) {
          List<RegionModel>? modelList =
              ModalRoute.of(context)!.settings.arguments as List<RegionModel>?;
          return RegionPrintPage(modelList: modelList ?? []);
        },
        '/healthplantype/list': (_) => const HealthPlanTypeListPage(),
        '/healthplantype/save': (_) => const HealthPlanTypeSavePage(),
        '/healthplantype/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return HealthPlanTypeSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/healthplantype/print': (context) {
          List<HealthPlanTypeModel>? modelList = ModalRoute.of(context)!
              .settings
              .arguments as List<HealthPlanTypeModel>?;
          return HealthPlanTypePrintPage(modelList: modelList ?? []);
        },
        '/healthplan/save': (context) {
          HealthPlanModel? model =
              ModalRoute.of(context)!.settings.arguments as HealthPlanModel?;

          return HealthPlanSavePage(
            model: model,
          );
        },
        '/patient/search': (_) => const PatientSearchPage(),
        '/patient/save': (_) => const PatientSavePage(),
        '/patient/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return PatientSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/patient/print': (context) {
          List<PatientModel>? modelList =
              ModalRoute.of(context)!.settings.arguments as List<PatientModel>?;
          return PatientPrintPage(modelList: modelList ?? []);
        },
        '/room/list': (_) => const RoomListPage(),
        '/room/save': (_) => const RoomSavePage(),
        '/room/select': (context) {
          bool isSingleValue =
              ModalRoute.of(context)!.settings.arguments as bool;

          return RoomSelectPage(
            isSingleValue: isSingleValue,
          );
        },
        '/room/print': (context) {
          List<RoomModel>? modelList =
              ModalRoute.of(context)!.settings.arguments as List<RoomModel>?;
          return RoomPrintPage(modelList: modelList ?? []);
        },
      },
      initialRoute: '/',
    );
  }
}
