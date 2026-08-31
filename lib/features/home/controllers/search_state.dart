import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SearchItem extends Equatable {
  final String title;
  final String category;
  final IconData icon;

  const SearchItem(this.title, this.category, this.icon);

  @override
  List<Object?> get props => [title, category, icon];
}

class SearchState extends Equatable {
  final String query;
  final List<SearchItem> allItems;
  final List<SearchItem> filteredItems;

  const SearchState({
    this.query = "",
    this.allItems = const [],
    this.filteredItems = const [],
  });

  SearchState copyWith({
    String? query,
    List<SearchItem>? allItems,
    List<SearchItem>? filteredItems,
  }) {
    return SearchState(
      query: query ?? this.query,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }

  @override
  List<Object?> get props => [query, allItems, filteredItems];
}
