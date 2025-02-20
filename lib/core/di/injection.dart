import 'package:get_it/get_it.dart';
import '../network/api_client.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  print("👀 Registrando ApiClient en GetIt...");
  if (!locator.isRegistered<ApiClient>()) {
    locator.registerLazySingleton<ApiClient>(() => ApiClient());
    print("✅ ApiClient registrado exitosamente");
  } else {
    print("⚠️ ApiClient ya está registrado");
  }
}

