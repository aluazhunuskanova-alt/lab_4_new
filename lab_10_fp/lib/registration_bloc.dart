import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// EVENTS

abstract class RegistrationEvent {}

class RegistrationSubmitted extends RegistrationEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  RegistrationSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

/// STATES

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String message;
  RegistrationFailure(this.message);
}

/// BLOC

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationSubmitted>((event, emit) async {
      if (event.name.trim().isEmpty ||
          event.phone.trim().isEmpty ||
          event.email.trim().isEmpty ||
          event.password.isEmpty ||
          event.confirmPassword.isEmpty) {
        emit(RegistrationFailure('Please fill all fields'));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(RegistrationFailure('Passwords do not match'));
        return;
      }

      if (event.password.length < 6) {
        emit(RegistrationFailure('Password too short'));
        return;
      }

      emit(RegistrationLoading());
      try {
        // Firebase Auth – sign up or sign in
        await _auth.createUserWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password,
        );

        // SharedPreferences – remember user as logged in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logged_in', true);
        await prefs.setString('user_email', event.email.trim());

        emit(RegistrationSuccess());
      } on FirebaseAuthException catch (e) {
        emit(RegistrationFailure(e.message ?? 'Authentication failed'));
      } catch (_) {
        emit(RegistrationFailure('Something went wrong'));
      }
    });
  }
}
