part of 'user_profile_edit_bloc.dart';

abstract class UserProfileEditEvent {}

class UserProfileEditEventSendXFile extends UserProfileEditEvent {
  final XFile? xfile;
  UserProfileEditEventSendXFile({
    required this.xfile,
  });
}

class UserProfileEditEventFormSubmitted extends UserProfileEditEvent {
  final String name;
  final String cpf;
  final String phone;
  UserProfileEditEventFormSubmitted({
    required this.name,
    required this.cpf,
    required this.phone,
  });

  UserProfileEditEventFormSubmitted copyWith({
    String? nickname,
    String? name,
    String? cpf,
    String? phone,
  }) {
    return UserProfileEditEventFormSubmitted(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileEditEventFormSubmitted &&
        other.name == name &&
        other.cpf == cpf &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return name.hashCode ^ cpf.hashCode ^ phone.hashCode;
  }
}
