import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/diary_entry.dart';

class AIService {
  final Dio _dio;
  final String _apiKey;
  static const String _baseUrl = 'https://api.openai.com/v1';

  AIService({
    required String apiKey,
    Dio? dio,
  })  : _apiKey = apiKey,
        _dio = dio ?? Dio();

  // Analyze diary and generate feedback
  Future<AIFeedback> analyzeDiary(String content) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(),
            },
            {
              'role': 'user',
              'content': content,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      final result = response.data['choices'][0]['message']['content'];
      return _parseFeedback(result);
    } catch (e) {
      if (kDebugMode) {
        print('AI Service Error: $e');
      }
      // Return default feedback on error
      return _getDefaultFeedback();
    }
  }

  // Generate reflection questions
  Future<List<String>> generateQuestions(String content, String emotion) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a thoughtful counselor. Generate 2-3 reflection questions based on the diary content.',
            },
            {
              'role': 'user',
              'content': 'Diary: $content\nEmotion: $emotion',
            },
          ],
          'temperature': 0.8,
          'max_tokens': 200,
        }),
      );

      final result = response.data['choices'][0]['message']['content'];
      return _parseQuestions(result);
    } catch (e) {
      if (kDebugMode) {
        print('Question Generation Error: $e');
      }
      return _getDefaultQuestions(emotion);
    }
  }

  // Generate encouragement message
  Future<String> generateEncouragement(String emotion) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a warm and empathetic friend. Generate a short encouraging message (2-3 sentences).',
            },
            {
              'role': 'user',
              'content': 'The person is feeling: $emotion',
            },
          ],
          'temperature': 0.9,
          'max_tokens': 150,
        }),
      );

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      if (kDebugMode) {
        print('Encouragement Generation Error: $e');
      }
      return _getDefaultEncouragement(emotion);
    }
  }

  // Private helper methods

  String _getSystemPrompt() {
    return '''You are a warm, empathetic emotional wellness counselor.
Analyze the diary entry and provide:
1. Emotion analysis (JSON format with scores for: positive, negative, anxious, peaceful)
2. A warm, empathetic feedback message (2-3 sentences)
3. 1-2 positive highlights from the entry
4. 1-2 reflection questions

Format your response as JSON:
{
  "emotions": {"positive": 0.7, "negative": 0.1, "anxious": 0.2, "peaceful": 0.5},
  "message": "Your empathetic message here",
  "highlights": ["Highlight 1", "Highlight 2"],
  "questions": ["Question 1", "Question 2"]
}''';
  }

  AIFeedback _parseFeedback(String result) {
    try {
      // Try to parse JSON response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(result);
      if (jsonMatch != null) {
        final jsonData = jsonDecode(jsonMatch.group(0)!);

        return AIFeedback(
          emotionAnalysis: Map<String, double>.from(
            jsonData['emotions']?.map((k, v) => MapEntry(k, v.toDouble())) ??
                {},
          ),
          feedbackMessage: jsonData['message'] ??
              'Thank you for sharing your thoughts today.',
          positiveHighlights: List<String>.from(jsonData['highlights'] ?? []),
          reflectionQuestions: List<String>.from(jsonData['questions'] ?? []),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Parse error: $e');
      }
    }
    return _getDefaultFeedback();
  }

  List<String> _parseQuestions(String result) {
    final questions = <String>[];
    final lines = result.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty &&
          (trimmed.contains('?') || trimmed.startsWith('-'))) {
        questions.add(trimmed.replaceAll(RegExp(r'^[-\d.)\s]+'), '').trim());
      }
    }

    return questions.take(3).toList();
  }

  AIFeedback _getDefaultFeedback() {
    return AIFeedback(
      emotionAnalysis: {
        'positive': 0.5,
        'negative': 0.2,
        'anxious': 0.2,
        'peaceful': 0.4,
      },
      feedbackMessage:
          'Thank you for taking the time to write today. Your thoughts and feelings are valuable.',
      positiveHighlights: [
        'You took time for self-reflection',
      ],
      reflectionQuestions: [
        'What would make tomorrow better?',
        'What are you grateful for today?',
      ],
    );
  }

  List<String> _getDefaultQuestions(String emotion) {
    final questionMap = {
      'happy': [
        'What made this moment special?',
        'How can you create more moments like this?',
      ],
      'sad': [
        'What would help you feel better right now?',
        'Who could you reach out to for support?',
      ],
      'anxious': [
        'What can you control in this situation?',
        'What helps you feel calm?',
      ],
      'peaceful': [
        'What contributed to this sense of peace?',
        'How can you maintain this feeling?',
      ],
    };

    return questionMap[emotion] ?? questionMap['peaceful']!;
  }

  String _getDefaultEncouragement(String emotion) {
    final encouragementMap = {
      'happy':
          'It\'s wonderful to see you feeling joyful! May this positive energy continue to light up your days.',
      'sad':
          'It\'s okay to feel sad sometimes. Remember, this feeling is temporary, and brighter days are ahead.',
      'anxious':
          'Take a deep breath. You\'re stronger than you think, and you\'ve overcome challenges before.',
      'peaceful':
          'What a beautiful state of mind. Cherish this moment of peace and let it nourish your soul.',
    };

    return encouragementMap[emotion] ?? encouragementMap['peaceful']!;
  }
}
