import 'torch_service_stub.dart'
    if (dart.library.io) 'torch_service_mobile.dart';

/// Platform-aware torch access.
/// On Android/iOS this hits the hardware torch via `torch_light`.
/// On web/desktop it becomes a no-op + reports unavailable.
abstract class TorchService {
  factory TorchService() => createTorchService();

  Future<bool> isAvailable();
  Future<void> enable();
  Future<void> disable();
}
