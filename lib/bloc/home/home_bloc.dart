import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository/repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CharacterRepository characterRepository;
  List<Character> characters = [];

  HomeBloc({required this.characterRepository}) : super(HomeInitial()) {
    on<FetchCharacters>((event, emit) async {
      emit(HomeLoading());
      try {
        final newCharacters = await characterRepository.getAllCharacters(
            event.start, event.count);
        characters = [...characters, ...newCharacters];
        emit(HomeLoaded(characters));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
