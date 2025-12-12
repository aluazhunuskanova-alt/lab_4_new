import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile.dart';

/// EVENTS
abstract class NewsEvent {}

class LoadNews extends NewsEvent {}

/// STATES
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Profile> items;
  NewsLoaded(this.items);
}

class NewsFailure extends NewsState {
  final String message;
  NewsFailure(this.message);
}

/// BLOC
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final Dio dio;

  NewsBloc(this.dio) : super(NewsInitial()) {
    on<LoadNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final response = await dio.get<List<dynamic>>(
          'https://jsonplaceholder.typicode.com/posts',
        );
        final data = response.data ?? [];
        final posts = data
            .map((json) => Profile.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(NewsLoaded(posts));
      } catch (e) {
        emit(NewsFailure('Failed to load news'));
      }
    });
  }
}
