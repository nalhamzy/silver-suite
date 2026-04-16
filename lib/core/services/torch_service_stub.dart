import 'torch_service.dart';

TorchService createTorchService() => _StubTorchService();

class _StubTorchService implements TorchService {
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<void> enable() async {}
  @override
  Future<void> disable() async {}
}
