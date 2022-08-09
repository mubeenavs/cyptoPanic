import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cryptoPanic/home/repository/repository.dart';

import 'package:cryptoPanic/home/model/news.dart';

part 'home_event.dart';
part 'home_state.dart';
///event handler
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  HomeBloc(this._homeRepository) : super(LoadingState()) {
    on<LoadEvent>((event, emit) async {
      final activity = await _homeRepository.fetchNews();
      emit(LoadedState(
          activity.count, activity.next, activity.previous, activity.results));
    });
  }
}
