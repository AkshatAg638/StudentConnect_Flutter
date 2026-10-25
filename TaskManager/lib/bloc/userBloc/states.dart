abstract class UserStates {}

class InitialState extends UserStates {}

class EnableGoogleSignin extends UserStates {}

class Userloading extends UserStates {
  final bool loading;
  Userloading(this.loading);
}

class UserAuthenticated extends UserStates {}

class UserAuthenticationFailed extends UserStates {
  final String error;
  UserAuthenticationFailed(this.error);
}

class UserLoggedOut extends UserStates {}
