import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState()) {
    _loadItems();
  }

  void _loadItems() {
    const items = [
      SearchItem("Fullbody Workout", "Workout", Icons.fitness_center),
      SearchItem("Lowerbody Workout", "Workout", Icons.fitness_center),
      SearchItem("Ab Workout", "Workout", Icons.fitness_center),
      SearchItem("Upperbody Workout", "Workout", Icons.fitness_center),
      SearchItem("Grilled Chicken Salad", "Meal", Icons.restaurant),
      SearchItem("Protein Shake", "Meal", Icons.local_drink),
      SearchItem("Water Intake", "Activity", Icons.water_drop),
      SearchItem("Sleep Tracker", "Activity", Icons.bedtime),
      SearchItem("Heart Rate", "Activity", Icons.favorite),
      SearchItem("BMI Calculator", "Tool", Icons.monitor_weight),
    ];
    emit(state.copyWith(allItems: items));
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      emit(state.copyWith(query: query, filteredItems: []));
      return;
    }

    final filtered = state.allItems
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    emit(state.copyWith(query: query, filteredItems: filtered));
  }

  void clearSearch() {
    emit(state.copyWith(query: "", filteredItems: []));
  }
}
