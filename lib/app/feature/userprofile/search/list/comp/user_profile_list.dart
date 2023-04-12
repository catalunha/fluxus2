import 'package:flutter/material.dart';

import '../../../../../core/models/user_profile_model.dart';
import 'user_profile_card.dart';

class UserProfileList extends StatelessWidget {
  final List<UserProfileModel> userProfileList;
  const UserProfileList({
    super.key,
    required this.userProfileList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userProfileList.length,
      itemBuilder: (context, index) {
        final person = userProfileList[index];
        return UserProfileCard(
          userProfile: person,
        );
      },
    );
  }
}
