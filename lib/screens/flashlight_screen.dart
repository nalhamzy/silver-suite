import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/services/torch_service.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  final TorchService _torch = TorchService();
  bool _on = false;
  bool _torchAvailable = true;
  String? _error;
  bool _screenMode = false;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final avail = await _torch.isAvailable();
    if (!mounted) return;
    setState(() => _torchAvailable = avail);
  }

  Future<void> _toggle() async {
    HapticFeedback.mediumImpact();
    try {
      if (_on) {
        await _torch.disable();
      } else {
        await _torch.enable();
      }
      if (!mounted) return;
      setState(() {
        _on = !_on;
        _error = null;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = _describeError(e));
    }
  }

  @override
  void dispose() {
    if (_on) {
      _torch.disable().catchError((_) {});
    }
    super.dispose();
  }

  String _describeError(Exception e) {
    final s = e.toString();
    if (s.contains('NotAvailable')) return 'No flashlight on this device.';
    return 'Could not control flashlight.';
  }

  @override
  Widget build(BuildContext context) {
    final background = _screenMode
        ? Colors.white
        : (_on ? const Color(0xFF0C0F15) : AppTheme.bg);
    final ink = _screenMode
        ? Colors.black
        : (_on ? Colors.white : AppTheme.ink);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        title: Text('Flashlight', style: TextStyle(color: ink)),
        iconTheme: IconThemeData(color: ink),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _torchAvailable ? _toggle : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _on ? AppTheme.amberGradient : null,
                    color: _on ? null : AppTheme.blue.withValues(alpha: 0.1),
                    border: Border.all(
                      color: _on ? AppTheme.amber : AppTheme.blue,
                      width: 3,
                    ),
                    boxShadow: _on
                        ? [
                            BoxShadow(
                              color: AppTheme.amber.withValues(alpha: 0.6),
                              blurRadius: 60,
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _on
                        ? Icons.flashlight_on
                        : Icons.flashlight_off,
                    color: _on ? Colors.white : AppTheme.blue,
                    size: 90,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _on ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: _on ? AppTheme.amber : ink,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              if (!_torchAvailable)
                Text(
                  'No camera flashlight detected on this device.\nUse "Screen Light" below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ink, fontSize: 14),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!,
                      style:
                          const TextStyle(color: AppTheme.red, fontSize: 14)),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: ink.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    foregroundColor: ink,
                  ),
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(
                    _screenMode ? 'Dim screen' : 'Screen light',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    setState(() => _screenMode = !_screenMode);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
