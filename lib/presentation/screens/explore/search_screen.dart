// lib/presentation/screens/explore/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/users_provider.dart';
import '../../widgets/common/search_input.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: SearchInput(
          controller: _searchController,
          onChanged: (query) {
            ref.read(usersProvider.notifier).searchUsers(query);
          },
        ),
      ),
      body: usersState.isSearching
          ? const Center(child: CircularProgressIndicator())
          : usersState.searchResults.isEmpty
              ? Center(
                  child: Text(
                    'No results found',
                    style: AppTypography.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: usersState.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = usersState.searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text(user.name, style: AppTypography.labelLarge),
                      subtitle: Text(user.username, style: AppTypography.caption),
                      trailing: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(usersProvider.notifier)
                              .toggleFollow(user.id);
                        },
                        child: Text(user.isFollowing ? 'Following' : 'Follow'),
                      ),
                    );
                  },
                ),
    );
  }
}
