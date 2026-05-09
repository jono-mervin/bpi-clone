import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;

  UserProfile({required this.name, this.email = ''});
}

class UserNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return UserProfile(name: 'Joe Lopez');
  }

  void updateName(String newName) {
    state = UserProfile(name: newName, email: state.email);
  }
}

final userProvider = NotifierProvider<UserNotifier, UserProfile>(UserNotifier.new);
