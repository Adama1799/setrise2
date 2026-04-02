// lib/presentation/screens/live/go_live_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/live_provider.dart';

class GoLiveScreen extends ConsumerStatefulWidget {
  const GoLiveScreen({super.key});

  @override
  ConsumerState<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends ConsumerState<GoLiveScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isStreaming = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Go Live'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: const Center(
                child: Icon(Icons.videocam, size: 80, color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 24),
            // Title Input
            Text('Stream Title', style: AppTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter stream title',
                hintStyle: AppTypography.caption,
              ),
              style: AppTypography.bodyMedium,
              maxLength: 100,
            ),
            const SizedBox(height: 20),
            // Description Input
            Text('Description', style: AppTypography.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Describe your stream',
                hintStyle: AppTypography.caption,
              ),
              style: AppTypography.bodyMedium,
              maxLines: 4,
              maxLength: 500,
            ),
            const SizedBox(height: 24),
            // Privacy Settings
            Text('Privacy', style: AppTypography.labelLarge),
            const SizedBox(height: 12),
            RadioListTile<String>(
              value: 'public',
              groupValue: 'public',
              onChanged: (_) {},
              title: const Text('Public', style: AppTypography.labelMedium),
              subtitle: const Text(
                'Anyone can watch',
                style: AppTypography.caption,
              ),
            ),
            RadioListTile<String>(
              value: 'followers',
              groupValue: 'public',
              onChanged: (_) {},
              title: const Text('Followers Only', style: AppTypography.labelMedium),
              subtitle: const Text(
                'Only your followers',
                style: AppTypography.caption,
              ),
            ),
            const SizedBox(height: 24),
            // Go Live Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  ref.read(liveProvider.notifier).startLiveStream(
                    _titleController.text,
                    _descriptionController.text,
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.live,
                ),
                child: const Text(
                  'Go Live',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
