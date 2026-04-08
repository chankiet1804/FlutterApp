import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final _provider = FirebaseProvider(
    model: FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash-lite',
    ),
  );

  @override
  void initState() {
    super.initState();
    _provider.addListener(_saveHistory);
    _loadHistory();
  }

  @override
  void dispose() {
    _provider.removeListener(_saveHistory);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Flutter AI Toolkit'),
      actions: [
        IconButton(onPressed: _clearHistory, icon: const Icon(Icons.history)),
      ],
    ),
    body: LlmChatView(
      provider: _provider,
      welcomeMessage: _welcomeMessage,
      style: _getChatStyle(context),
      suggestions: const [
        'I\'m a Star Wars fan. What should I wear for Halloween?',
        'I\'m allergic to peanuts. What candy should I avoid at Halloween?',
        'What\'s the difference between a pumpkin and a squash?',
      ],
    ),
  );

  LlmChatViewStyle _getChatStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LlmChatViewStyle(
      backgroundColor: colorScheme.surface,
      suggestionStyle: SuggestionStyle(
        textStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
      ),
      chatInputStyle: ChatInputStyle(
        backgroundColor: colorScheme.surfaceContainerLowest,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        textStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      userMessageStyle: UserMessageStyle(
        textStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.zero,
          ),
        ),
      ),
      llmMessageStyle: LlmMessageStyle(
        iconColor: colorScheme.onTertiaryContainer,
        iconDecoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.zero,
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      recordButtonStyle: ActionButtonStyle(iconColor: colorScheme.primary),
      submitButtonStyle: ActionButtonStyle(iconColor: colorScheme.primary),
      attachFileButtonStyle: ActionButtonStyle(
        iconColor: colorScheme.onSurfaceVariant,
      ),
      cameraButtonStyle: ActionButtonStyle(
        iconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  io.Directory? _historyDir;

  final _welcomeMessage = 'Hello and welcome to the Flutter AI Toolkit!';

  Future<io.Directory> _getHistoryDir() async {
    if (_historyDir == null) {
      final temp = await pp.getTemporaryDirectory();
      _historyDir = io.Directory(path.join(temp.path, 'chat-history'));
      await _historyDir!.create();
    }
    return _historyDir!;
  }

  Future<io.File> _messageFile(int messageNo) async {
    final fileName = path.join(
      (await _getHistoryDir()).path,
      'message-${messageNo.toString().padLeft(3, '0')}.json',
    );
    return io.File(fileName);
  }

  Future<void> _loadHistory() async {
    // read the history from disk
    final history = <ChatMessage>[];
    for (var i = 0; ; ++i) {
      final file = await _messageFile(i);
      if (!file.existsSync()) break;

      debugPrint('Loading: ${file.path}');
      final map = jsonDecode(await file.readAsString());
      history.add(ChatMessage.fromJson(map));
    }

    // set the history on the controller
    _provider.history = history;
  }

  Future<void> _saveHistory() async {
    // get the latest history
    final history = _provider.history.toList();

    // write the new messages
    for (var i = 0; i != history.length; ++i) {
      // skip if the file already exists
      final file = await _messageFile(i);
      if (file.existsSync()) continue;

      // write the new message to disk
      debugPrint('Saving: ${file.path}');
      final map = history[i].toJson();
      final json = JsonEncoder.withIndent('  ').convert(map);
      await file.writeAsString(json);
    }
  }

  void _clearHistory() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    // delete any old messages
    for (var i = 0; ; ++i) {
      final file = await _messageFile(i);
      if (!file.existsSync()) break;
      debugPrint('Deleting: ${file.path}');
      await file.delete();
    }

    _provider.history = [];
  }
}
