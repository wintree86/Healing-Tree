import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiaryDetailScreen extends StatelessWidget {
  final String diaryId;

  const DiaryDetailScreen({
    super.key,
    required this.diaryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: Show delete confirmation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Emotion
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateTime.now().toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                const Text('😊 Happy'),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Sample Diary Entry',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Content
            Text(
              'This is a sample diary entry. The actual content will be loaded from the database.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            // AI Feedback Section
            Container(
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
                      const Icon(Icons.psychology),
                      const SizedBox(width: 8),
                      Text(
                        'AI Feedback',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AI feedback will appear here after analysis.',
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
