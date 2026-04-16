import 'package:flutter/material.dart';
import '../../../data/models/dating_profile_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
  List<DatingProfileModel> _filteredProfiles = [];

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProfiles = [];
      });
      return;
    }

    setState(() {
      _filteredProfiles = widget.profiles.where((profile) {
        final nameMatch = profile.name.toLowerCase().contains(query.toLowerCase());
        final cityMatch = profile.city.toLowerCase().contains(query.toLowerCase());
        final interestMatch = profile.interests.any(
          (interest) => interest.toLowerCase().contains(query.toLowerCase()),
        );
        return nameMatch || cityMatch || interestMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'البحث',
                    style: AppTextStyles.h4,
                  ),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم، المدينة، أو الاهتمام...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey1),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Results
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 64,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ابدأ البحث عن أشخاص',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey1,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _filteredProfiles.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد نتائج مطابقة',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey1,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredProfiles.length,
                          itemBuilder: (context, index) {
                            final profile = _filteredProfiles[index];
                            return _buildProfileTile(profile);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(DatingProfileModel profile) {
    return GestureDetector(
      onTap: () {
        widget.onMatchFound(profile);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profile.imageUrls[0],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: AppTextStyles.labelLarge,
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.neonBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.grey1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.city,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: profile.interests
                        .take(2)
                        .map((interest) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey3,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                interest,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
