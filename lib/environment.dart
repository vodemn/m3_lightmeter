enum BuildType { dev, prod }

class Environment {
  final BuildType buildType;
  final bool hasLightSensor;

  const Environment({
    required this.buildType,
    this.hasLightSensor = false,
  });

  const Environment.dev()
      : buildType = BuildType.dev,
        hasLightSensor = false;

  const Environment.prod()
      : buildType = BuildType.prod,
        hasLightSensor = false;

  Environment copyWith({bool? hasLightSensor}) => Environment(
        buildType: buildType,
        hasLightSensor: hasLightSensor ?? this.hasLightSensor,
      );
}
