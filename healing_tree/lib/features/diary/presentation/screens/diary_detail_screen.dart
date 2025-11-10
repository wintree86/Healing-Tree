import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/diary_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DiaryDetailScreen extends ConsumerWidget {
  final String diaryId;

  const DiaryDetailScreen({
    super.key,
    required this.diaryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryAsync = ref.watch(diaryProvider(diaryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Toggle favorite
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: diaryAsync.when(
        data: (diary) {
          if (diary == null) {
            return const Center(child: Text('Diary not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Emotions
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(diary.createdAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    ...diary.emotions.take(3).map((emotion) {
                      final emoji = AppConstants.emotionEmojis[emotion] ?? '•';
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(emoji, style: const TextStyle(fontSize: 18)),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                if (diary.title != null && diary.title!.isNotEmpty) ...[
                  Text(
                    diary.title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                ],

                // Content
                Text(
                  diary.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),

                // AI Feedback Section
                if (diary.aiFeedback != null)
                  _buildAIFeedback(context, diary.aiFeedback!)
                else
                  _buildNoAIFeedback(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildAIFeedback(BuildContext context, feedback) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Feedback',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Emotion Analysis
          if (feedback.emotionAnalysis.isNotEmpty) ...[
            Text(
              'Emotion Analysis',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: feedback.emotionAnalysis.entries.map((entry) {
                final percentage = (entry.value * 100).toInt();
                return Chip(
                  label: Text('${entry.key}: $percentage%'),
                  backgroundColor: _getEmotionColor(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Feedback Message
          Text(
            feedback.feedbackMessage,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          // Positive Highlights
          if (feedback.positiveHighlights != null &&
              feedback.positiveHighlights!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '✨ Positive Highlights',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...feedback.positiveHighlights!.map((highlight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(highlight)),
                    ],
                  ),
                )),
          ],

          // Reflection Questions
          if (feedback.reflectionQuestions != null &&
              feedback.reflectionQuestions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '💭 Reflection Questions',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...feedback.reflectionQuestions!.map((question) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '• $question',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildNoAIFeedback(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'AI feedback is not available for this entry.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'positive':
      case 'happy':
        return Colors.green.shade100;
      case 'negative':
      case 'sad':
        return Colors.red.shade100;
      case 'anxious':
        return Colors.orange.shade100;
      case 'peaceful':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Diary'),
        content: const Text('Are you sure you want to delete this diary entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(diaryListProvider.notifier).deleteDiary(diaryId);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                context.pop(); // Go back to list
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
