enum BuildType { dev, prod }

class Environment {
  final BuildType buildType;
  final String sourceCodeUrl;
  final String issuesReportUrl;
  final String contactEmail;

  final bool hasLightSensor;

  const Environment({
    required this.buildType,
    required this.sourceCodeUrl,
    required this.issuesReportUrl,
    required this.contactEmail,
    this.hasLightSensor = false,
  });

  const Environment.dev()
      : buildType = BuildType.dev,
        sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues/new/choose',
        contactEmail = 'contact.vodemn@gmail.com',
        hasLightSensor = false;

  const Environment.prod()
      : buildType = BuildType.prod,
        sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues/new/choose',
        contactEmail = 'contact.vodemn@gmail.com',
        hasLightSensor = false;

  Environment copyWith({bool? hasLightSensor}) => Environment(
        buildType: buildType,
        sourceCodeUrl: sourceCodeUrl,
        issuesReportUrl: issuesReportUrl,
        contactEmail: contactEmail,
        hasLightSensor: hasLightSensor ?? this.hasLightSensor,
      );
}
