part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}
/// loading state
class LoadingState extends HomeState {
  @override
  List<Object> get props => [];
}
///loaded State
class LoadedState extends HomeState {
  int? count;
  String? next;
  dynamic previous;
  List<Result>? results;

  LoadedState(this.count, this.next, this.previous, this.results);

  @override
  ///response
  List<Object?> get props => [
        count,
        next,
        previous,
        results,
      ];
}
