import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silver_suite/core/constants/theme.dart';

/// Intentionally simple calculator with BIG keys and HIGH contrast.
/// No scientific functions — just the daily math seniors actually do.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _acc;
  String? _op;
  bool _justEvaluated = false;

  void _onDigit(String d) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_justEvaluated) {
        _display = d == '.' ? '0.' : d;
        _justEvaluated = false;
      } else if (_display == '0' && d != '.') {
        _display = d;
      } else if (d == '.' && _display.contains('.')) {
        return;
      } else {
        _display = '$_display$d';
      }
    });
  }

  void _onOp(String op) {
    HapticFeedback.selectionClick();
    final current = double.tryParse(_display);
    if (current == null) return;
    setState(() {
      if (_acc == null || _op == null) {
        _acc = current;
      } else {
        _acc = _compute(_acc!, current, _op!);
      }
      _op = op;
      _display = _format(_acc!);
      _justEvaluated = true;
    });
  }

  void _equals() {
    HapticFeedback.mediumImpact();
    if (_acc == null || _op == null) return;
    final current = double.tryParse(_display);
    if (current == null) return;
    setState(() {
      _acc = _compute(_acc!, current, _op!);
      _display = _format(_acc!);
      _op = null;
      _justEvaluated = true;
    });
  }

  void _clear() {
    HapticFeedback.lightImpact();
    setState(() {
      _display = '0';
      _acc = null;
      _op = null;
      _justEvaluated = false;
    });
  }

  void _backspace() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_justEvaluated || _display.length <= 1 || _display == '0') {
        _display = '0';
        _justEvaluated = false;
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  double _compute(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? 0 : a / b;
    }
    return b;
  }

  String _format(double v) {
    if (v == v.roundToDouble() && v.abs() < 1e15) return v.toInt().toString();
    return v.toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  alignment: Alignment.bottomRight,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _display,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _row([
                    _KeyBtn('C', AppTheme.red, onTap: _clear, big: true),
                    _KeyBtn('⌫', AppTheme.mute, onTap: _backspace, big: true),
                    _KeyBtn('÷', AppTheme.blue,
                        onTap: () => _onOp('÷'), big: true),
                  ]),
                  _row([
                    _KeyBtn('7', AppTheme.ink, onTap: () => _onDigit('7')),
                    _KeyBtn('8', AppTheme.ink, onTap: () => _onDigit('8')),
                    _KeyBtn('9', AppTheme.ink, onTap: () => _onDigit('9')),
                    _KeyBtn('×', AppTheme.blue,
                        onTap: () => _onOp('×'), big: true),
                  ]),
                  _row([
                    _KeyBtn('4', AppTheme.ink, onTap: () => _onDigit('4')),
                    _KeyBtn('5', AppTheme.ink, onTap: () => _onDigit('5')),
                    _KeyBtn('6', AppTheme.ink, onTap: () => _onDigit('6')),
                    _KeyBtn('-', AppTheme.blue,
                        onTap: () => _onOp('-'), big: true),
                  ]),
                  _row([
                    _KeyBtn('1', AppTheme.ink, onTap: () => _onDigit('1')),
                    _KeyBtn('2', AppTheme.ink, onTap: () => _onDigit('2')),
                    _KeyBtn('3', AppTheme.ink, onTap: () => _onDigit('3')),
                    _KeyBtn('+', AppTheme.blue,
                        onTap: () => _onOp('+'), big: true),
                  ]),
                  _row([
                    _KeyBtn('0', AppTheme.ink,
                        onTap: () => _onDigit('0'), flex: 2),
                    _KeyBtn('.', AppTheme.ink, onTap: () => _onDigit('.')),
                    _KeyBtn('=', AppTheme.green,
                        onTap: _equals, big: true),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(List<_KeyBtn> keys) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          for (final k in keys) ...[
            Expanded(flex: k.flex, child: k),
            if (k != keys.last) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _KeyBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool big;
  final int flex;
  const _KeyBtn(
    this.label,
    this.color, {
    required this.onTap,
    this.big = false,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isOp = big && label != '=' && label != 'C' && label != '⌫';
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = big
        ? color
        : (dark ? const Color(0xFF1B2029) : const Color(0xFFF0F0F3));
    final fg = big ? Colors.white : (dark ? Colors.white : AppTheme.ink);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 74,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isOp ? 34 : 30,
              fontWeight: FontWeight.w900,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
