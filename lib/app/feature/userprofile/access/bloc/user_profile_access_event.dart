abstract class UserProfileAccessEvent {}

class UserProfileAccessEventFormSubmitted extends UserProfileAccessEvent {
  final bool isActive;
  UserProfileAccessEventFormSubmitted({
    required this.isActive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessEventFormSubmitted &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => isActive.hashCode;

  UserProfileAccessEventFormSubmitted copyWith({
    bool? isActive,
  }) {
    return UserProfileAccessEventFormSubmitted(
      isActive: isActive ?? this.isActive,
    );
  }
}

class UserProfileAccessEventUpdateAccess extends UserProfileAccessEvent {
  final String access;
  UserProfileAccessEventUpdateAccess({
    required this.access,
  });
}
