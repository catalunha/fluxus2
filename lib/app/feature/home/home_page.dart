import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';
import 'comp/home_card_module.dart';
import 'comp/home_popmenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Text(
                "Olá, ${state.user?.userProfile?.nickname ?? 'Atualize seu perfil.'}.");
          },
        ),
        actions: const [
          HomePopMenu(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              HomeCardModule(
                title: 'Usuários',
                access: const ['admin'],
                onAction: () {
                  Navigator.of(context).pushNamed('/userProfile/search');
                },
                icon: Icons.people,
                color: Colors.black,
              ),
              HomeCardModule(
                title: 'Graduações',
                access: const ['admin'],
                icon: Icons.school,
                color: Colors.black87,
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('/graduation/save');
                  //   },
                  //   icon: const Icon(Icons.add),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/graduation/list');
                    },
                    icon: const Icon(Icons.list),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Especialidades',
                access: const ['admin'],
                icon: Icons.folder_special,
                color: Colors.black87,
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('/expertise/save');
                  //   },
                  //   icon: const Icon(Icons.add),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/expertise/list');
                    },
                    icon: const Icon(Icons.list),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Tipos de Planos de Saúde',
                access: const ['admin'],
                icon: Icons.credit_card_rounded,
                color: Colors.black87,
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('/healthplantype/save');
                  //   },
                  //   icon: const Icon(Icons.add),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/healthplantype/list');
                    },
                    icon: const Icon(Icons.list),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Salas',
                access: const ['admin'],
                icon: Icons.house_sharp,
                color: Colors.black87,
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('/healthplantype/save');
                  //   },
                  //   icon: const Icon(Icons.add),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/room/list');
                    },
                    icon: const Icon(Icons.list),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Status',
                access: const ['admin'],
                icon: Icons.start,
                color: Colors.black87,
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed('/healthplantype/save');
                  //   },
                  //   icon: const Icon(Icons.add),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/status/list');
                    },
                    icon: const Icon(Icons.list),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Regiões',
                access: const ['admin'],
                icon: Icons.bubble_chart_outlined,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/region/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/region/search');
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Procedimentos',
                access: const ['admin'],
                icon: Icons.construction_sharp,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/procedure/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/procedure/search');
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              HomeCardModule(
                title: 'Pacientes',
                access: const ['admin'],
                icon: Icons.personal_injury,
                color: Colors.black87,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/patient/save');
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/patient/search');
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
