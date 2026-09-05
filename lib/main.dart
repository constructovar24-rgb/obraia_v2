import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'core/environment/environment_profile_store.dart';
import 'features/environment/presentation/providers/environment_controller.dart';
import 'features/environment/presentation/widgets/environment_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentController? controller;
  try {
    final documents = await getApplicationDocumentsDirectory();
    final profile = EnvironmentProfileStore(documents);
    controller = EnvironmentController(
      documentsDirectory: documents,
      profileStore: profile,
      initialEnvironment: await profile.read(),
      detachSession: () => WidgetsBinding.instance.endOfFrame,
    );
    await controller.lifecycle.activeDatabase.ensureReady();
    runApp(EnvironmentSession(controller: controller));
  } catch (_) {
    await controller?.close();
    controller?.dispose();
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'No se pudo abrir el entorno de OBRA IA. Revisa el perfil de arranque y la disponibilidad de la carpeta de datos.',
            ),
          ),
        ),
      ),
    );
  }
}
