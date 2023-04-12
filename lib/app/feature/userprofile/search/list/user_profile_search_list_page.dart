import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_profile_search_bloc.dart';
import '../bloc/user_profile_search_event.dart';
import '../bloc/user_profile_search_state.dart';
import 'comp/user_profile_list.dart';

class UserProfileSearchListPage extends StatelessWidget {
  const UserProfileSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UserProfileSearchListView();
  }
}

/*
class UserProfileSearchListPage extends StatelessWidget {
  const UserProfileSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: BlocProvider.of<UserProfileSearchBloc>(context),
        child: const UserProfileSearchListView(),
      ),
    );
    // return Scaffold(
    //   body: RepositoryProvider.value(
    //     value: (_) => RepositoryProvider.of<UserProfileRepository>(context),
    //     child: BlocProvider.value(
    //       value: BlocProvider.of<UserProfileSearchBloc>(context),
    //       child: const UserProfileSearchListView(),
    //     ),
    //   ),
    // );
  }
}
*/
class UserProfileSearchListView extends StatelessWidget {
  const UserProfileSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => UserProfilePrintPage());
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<UserProfileSearchBloc, UserProfileSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<UserProfileSearchBloc>()
                                .add(UserProfileSearchEventPreviousPage());
                          },
                    child: Card(
                      color: state.firstPage ? Colors.black : Colors.black45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: state.firstPage
                              ? const Text('Primeira página')
                              : const Text('Página anterior'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<UserProfileSearchBloc, UserProfileSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<UserProfileSearchBloc>()
                                .add(UserProfileSearchEventNextPage());
                          },
                    child: Card(
                      color: state.lastPage ? Colors.black : Colors.black45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: state.lastPage
                              ? const Text('Última página')
                              : const Text('Próxima página'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: BlocBuilder<UserProfileSearchBloc, UserProfileSearchState>(
                builder: (context, state) {
                  return UserProfileList(
                    userProfileList: state.userProfileModelList,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
