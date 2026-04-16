// lib/presentation/screens/date/search_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';

class DateSearchScreen extends StatefulWidget {
  final List<DatingProfileModel> profiles;
  final Function(DatingProfileModel) onMatchFound;

  const DateSearchScreen({
    super.key,
    required this.profiles,
    required this.onMatchFound,
  });

  @override
  State<DateSearchScreen> createState() => _DateSearchScreenState();
}

class _DateSearchScreenState extends State<DateSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DatingProfileModel> _searchResults = [];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() {
      _searchResults = widget.profiles.where((profile) {
        return profile.name.toLowerCase().contains(query.toLowerCase()) ||
            profile.city.toLowerCase().contains(query.toLowerCase()) ||
            profile.interests.any((interest) => interest.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: 'Search by name, city, or interest...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.grey2),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _searchResults.isEmpty && _searchController.text.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, color: AppColors.grey2, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Search for people',
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey2),
                  ),
                ],
              ),
            )
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_rounded, color: AppColors.grey2, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.grey2),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final profile = _searchResults[index];
                    return _SearchResultCard(profile: profile);
                  },
                ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final DatingProfileModel profile;

  const _SearchResultCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // يمكن فتح صفحة الملف الشخصي
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                profile.imageUrls.first,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.grey,
                  child: const Icon(Icons.person, color: AppColors.grey2),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${profile.name}, ${profile.age}',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: AppColors.electricBlue, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.grey2, size: 12),
                      const SizedBox(width: 2),
                      Text('${profile.city} · ${profile.distance}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.interests.join(' · '),
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.dating),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
