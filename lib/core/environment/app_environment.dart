enum AppEnvironment {
  development('Desarrollo'),
  production('Producción');

  const AppEnvironment(this.label);
  final String label;

  static AppEnvironment parse(Object? value) => switch (value) {
    'development' => development,
    'production' => production,
    _ => throw const FormatException('Entorno de OBRA IA no reconocido.'),
  };
}
