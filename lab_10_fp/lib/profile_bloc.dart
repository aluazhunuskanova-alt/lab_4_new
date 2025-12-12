import 'package:flutter_bloc/flutter_bloc.dart';

import 'rest_client.dart';
import 'profile.dart';

/// EVENTS
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

/// STATES
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  ProfileLoaded(this.profile);
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

/// BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final RestClient client;

  ProfileBloc(this.client) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await client.getProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileFailure('Failed to load profile'));
      }
    });
  }
}
