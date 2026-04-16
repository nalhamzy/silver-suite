import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silver_suite/core/constants/theme.dart';

/// Camera-free magnifier: type/paste small text and magnify it on screen.
/// Also supports a text-to-display flash-card mode: big, readable text.
class MagnifierScreen extends StatefulWidget {
  const MagnifierScreen({super.key});

  @override
  State<MagnifierScreen> createState() => _MagnifierScreenState();
}

class _MagnifierScreenState extends State<MagnifierScreen> {
  final TextEditingController _ctrl = TextEditingController();
  double _scale = 56;
  bool _highContrast = false;
  bool _bold = true;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _highContrast ? Colors.black : AppTheme.bg;
    final fg = _highContrast ? Colors.yellow : AppTheme.ink;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Magnifier'),
        backgroundColor: bg,
        foregroundColor: fg,
        actions: [
          IconButton(
            icon: Icon(
              _highContrast
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_outlined,
              color: fg,
            ),
            onPressed: () => setState(() => _highContrast = !_highContrast),
          ),
          IconButton(
            icon: Icon(
              _bold ? Icons.format_bold : Icons.format_italic,
              color: fg,
            ),
            onPressed: () => setState(() => _bold = !_bold),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _highContrast ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _highContrast
                      ? Colors.yellow.withValues(alpha: 0.5)
                      : AppTheme.outline,
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _ctrl.text.isEmpty
                      ? 'Your magnified text shows up here.\n\nType below to try it.'
                      : _ctrl.text,
                  style: TextStyle(
                    fontSize: _scale,
                    fontWeight: _bold ? FontWeight.w800 : FontWeight.w500,
                    color: fg,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.text_decrease, size: 22),
                Expanded(
                  child: Slider(
                    min: 24,
                    max: 120,
                    divisions: 24,
                    value: _scale,
                    activeColor: AppTheme.blue,
                    label: _scale.round().toString(),
                    onChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() => _scale = v);
                    },
                  ),
                ),
                const Icon(Icons.text_increase, size: 30),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
            child: TextField(
              controller: _ctrl,
              minLines: 2,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 18, color: fg),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    _highContrast ? Colors.grey[900] : AppTheme.surface,
                hintText: 'Type or paste text to magnify…',
                hintStyle: TextStyle(
                  color: fg.withValues(alpha: 0.6),
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.blue, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
