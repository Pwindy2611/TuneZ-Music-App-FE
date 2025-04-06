import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tunezmusic/data/services/api_service.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService apiService;
  Timer? _debounce;

  SearchBloc(this.apiService): super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ResetSearchStateEvent>(_onResetState);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(results: [], isLoading: false));
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!isClosed) {
      emit(state.copyWith(isLoading: true));
      try {
        print('Searching for: ${event.query}');
        final response = await apiService.get('search/search/${event.query}');
        print('Search response: $response');
        
        if (response['success'] == true && response['data'] != null) {
          final results = response['data']['combinedResults'] as List? ?? [];
          print('Search results: $results');
          if (!isClosed) {
            emit(state.copyWith(
              results: results,
              isLoading: false,
            ));
          }
        } else {
          print('Search failed: ${response['message']}');
          if (!isClosed) {
            emit(state.copyWith(
              error: response['message'] ?? 'Search failed',
              isLoading: false,
            ));
          }
        }
      } catch (e) {
        print('Search error: $e');
        if (!isClosed) {
          emit(state.copyWith(
            error: e.toString(),
            isLoading: false,
          ));
        }
      }
    }
  }

  void _onResetState(ResetSearchStateEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
} 