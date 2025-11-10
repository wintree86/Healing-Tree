import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  State<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedEmotion;

  final List<Map<String, String>> _emotions = [
    {'name': 'happy', 'emoji': '😊'},
    {'name': 'sad', 'emoji': '😢'},
    {'name': 'excited', 'emoji': '🤗'},
    {'name': 'peaceful', 'emoji': '😌'},
    {'name': 'anxious', 'emoji': '😰'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Diary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveDiary,
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
              children: _emotions.map((emotion) {
                final isSelected = _selectedEmotion == emotion['name'];
                return ChoiceChip(
                  label: Text('${emotion['emoji']} ${emotion['name']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedEmotion = selected ? emotion['name'] : null;
                    });
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

  void _saveDiary() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diary saved! (Implementation pending)')),
    );
    context.pop();
  }
}
