import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/loading/loading.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/search/bloc/search_bloc.dart';
import 'package:tunezmusic/presentation/search/widgets/search_result_item.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchView();
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: "Bạn muốn nghe gì...",
                    hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                         _focusNode.unfocus();
                        context.read<NavigationBloc>().add(
                               BackToSearchEvent());
                      },
                    ),
                    suffixIcon: const Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onChanged: (query) {
                    context.read<SearchBloc>().add(SearchQueryChanged(query));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return DotsLoading();
                    }
                    
                    if (state.error != null) {
                      return Center(child: Text(state.error!));
                    }

                    if (state.results.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.results.length,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      itemBuilder: (context, index) {
                        final item = state.results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SearchResultItem(
                            item: item,
                            allTracks: state.results.where((r) => r['type'] == 'Song').map((r) => r['_id']).toList(),
                            prColor: AppColors.primary,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 