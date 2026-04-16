import 'dart:io';
import 'package:torch_light/torch_light.dart';
import 'torch_service.dart';

TorchService createTorchService() {
  if (Platform.isAndroid || Platform.isIOS) {
    return _MobileTorchService();
  }
  return _DesktopTorchService();
}

class _MobileTorchService implements TorchService {
  @override
  Future<bool> isAvailable() async {
    try {
      return await TorchLight.isTorchAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> enable() => TorchLight.enableTorch();

  @override
  Future<void> disable() => TorchLight.disableTorch();
}

class _DesktopTorchService implements TorchService {
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<void> enable() async {}
  @override
  Future<void> disable() async {}
}
