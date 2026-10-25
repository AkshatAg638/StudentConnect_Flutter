import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studentconnect/data/Authentications/google_signin.dart';
import 'package:studentconnect/bloc/userBloc/events.dart';
import 'package:studentconnect/bloc/userBloc/states.dart';

class LoginSignUpBloc extends Bloc<UserEvents, UserStates> {
  LoginSignUpBloc() : super(InitialState()) {
    on<LoginSignupEvent>((event, emit) {
      emit(EnableGoogleSignin());
    });

    on<GoogleSigning>((event, emit) async {
      if (event.loading == true) {
        emit(Userloading(true));
        UserCredential? user = await Auth.googleSignin();
        if (user != null && user.user != null) {
          emit(Userloading(false));
          emit(UserAuthenticated());
        } else {
          emit(Userloading(false));
          emit(UserAuthenticationFailed("Sign in cancelled or failed"));
          emit(EnableGoogleSignin());
        }
      } else {
        emit(Userloading(false));
      }
    });

    on<Logout>((event, emit) async {
      emit(Userloading(true));
      await Auth.GoogleLogout();
      emit(Userloading(false));
      emit(UserLoggedOut());
    });
  }
}
