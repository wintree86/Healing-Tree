import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_form_provider.dart';
import '../../../../core/constants/app_constants.dart';

class DiaryWriteScreen extends ConsumerStatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  ConsumerState<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final List<Map<String, String>> _emotions = AppConstants.emotionTags
      .map((tag) => {
            'name': tag,
            'emoji': AppConstants.emotionEmojis[tag] ?? '•',
          })
      .toList();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    ref.read(diaryFormProvider.notifier).setTitle(_titleController.text);
  }

  void _onContentChanged() {
    ref.read(diaryFormProvider.notifier).setContent(_contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(diaryFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Diary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(diaryFormProvider.notifier).reset();
            context.pop();
          },
        ),
        actions: [
          if (formState.isLoading || formState.isGeneratingAI)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: formState.isValid ? _saveDiary : null,
              child: const Text('Save'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emotion Selection
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: _emotions.map((emotion) {
                final emotionName = emotion['name']!;
                final isSelected = formState.emotions.contains(emotionName);
                return ChoiceChip(
                  label: Text('${emotion['emoji']} $emotionName'),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(diaryFormProvider.notifier)
                        .toggleEmotion(emotionName);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (Optional)',
                hintText: 'Give your diary a title',
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),

            // Content Input
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Your thoughts',
                hintText: 'What\'s on your mind today?',
                alignLabelWithHint: true,
              ),
              maxLines: 15,
              maxLength: 10000,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDiary() async {
    final formState = ref.read(diaryFormProvider);

    if (!formState.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    // Show AI generation message if content is substantial
    if (formState.content.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving and generating AI feedback...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    final success = await ref.read(diaryFormProvider.notifier).saveDiary();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save diary'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
