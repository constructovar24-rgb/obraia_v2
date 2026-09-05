import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app.dart';
import '../../../../database/database_provider.dart';
import '../providers/environment_controller.dart';

/// Recreates providers, navigation and form state across environment changes.
class EnvironmentSession extends StatelessWidget {
  const EnvironmentSession({super.key, required this.controller});
  final EnvironmentController controller;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      if (controller.switching || !controller.available) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: controller.switching
                  ? const CircularProgressIndicator()
                  : Text(controller.error!),
            ),
          ),
        );
      }
      return ProviderScope(
        key: ValueKey(controller.session),
        overrides: [
          databaseLifecycleControllerProvider.overrideWith(
            (ref) => controller.lifecycle,
          ),
          environmentControllerProvider.overrideWith((ref) => controller),
        ],
        child: const ObraIAApp(),
      );
    },
  );
}
