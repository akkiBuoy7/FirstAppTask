import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'tv_guide_options_event.dart';
part 'tv_guide_options_state.dart';

class TvGuideOptionsBloc extends Bloc<TvGuideOptionsEvent, TvGuideOptionsState> {
  TvGuideOptionsBloc() : super(TvGuideOptionsInitial()) {
    on<TvGuideShowSearchEvent>((event, emit) {
      emit(TvGuideShowSearchState(event.showSearchBar));
    });

    on<TvGuideSelectItemEvent>((event, emit) {
      emit(TvGuideSelectItemState(event.value));
    });
  }
}
