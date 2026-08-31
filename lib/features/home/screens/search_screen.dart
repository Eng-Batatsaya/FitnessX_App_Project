import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/search_cubit.dart';
import '../controllers/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors),
            _buildSearchField(context, colors),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.query.trim().isEmpty) {
                    return _buildEmptyState(colors);
                  }
                  if (state.filteredItems.isEmpty) {
                    return _buildNoResults(state.query, colors);
                  }
                  return _buildResultsList(state.filteredItems, colors);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsResolved colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.grayColor3.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.chevron_left, color: colors.blackColor),
            ),
          ),
          Text(
            "Search",
            style: AppTextStyles.heading1.copyWith(color: colors.blackColor),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, AppColorsResolved colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colors.blackColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) => previous.query != current.query,
          builder: (context, state) {
            // Sync controller if needed (e.g. after clear)
            if (_controller.text != state.query) {
              _controller.text = state.query;
            }
            return TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => context.read<SearchCubit>().search(value),
              style: TextStyle(color: colors.blackColor),
              decoration: InputDecoration(
                hintText: "Search workouts, meals, activities...",
                hintStyle: TextStyle(color: colors.grayColor2, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: colors.grayColor2),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: colors.grayColor2),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().clearSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorsResolved colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 60, color: colors.grayColor3),
          const SizedBox(height: 15),
          Text(
            "Search for workouts, meals, or activities",
            style: TextStyle(color: colors.grayColor2, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String query, AppColorsResolved colors) {
    return Center(
      child: Text(
        "No results for \"$query\"",
        style: TextStyle(color: colors.grayColor2, fontSize: 13),
      ),
    );
  }

  Widget _buildResultsList(List<SearchItem> items, AppColorsResolved colors) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: colors.blackColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: colors.primaryColor2.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: colors.primaryColor1, size: 22),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.heading3.copyWith(fontSize: 14, color: colors.blackColor),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.category,
                      style: TextStyle(fontSize: 11, color: colors.grayColor2),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.grayColor2, size: 20),
            ],
          ),
        );
      },
    );
  }
}
