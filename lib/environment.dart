class Environment {
  final String sourceCodeUrl;
  final String issuesReportUrl;
  final String contactEmail;

  final bool hasLightSensor;

  const Environment({
    required this.sourceCodeUrl,
    required this.issuesReportUrl,
    required this.contactEmail,
    this.hasLightSensor = false,
  });

  const Environment.dev()
      : sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues',
        contactEmail = 'contact.vodemn@gmail.com',
        hasLightSensor = false;

  const Environment.prod()
      : sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues',
        contactEmail = 'contact.vodemn@gmail.com',
        hasLightSensor = false;

  Environment copyWith({bool? hasLightSensor}) => Environment(
        sourceCodeUrl: sourceCodeUrl,
        issuesReportUrl: issuesReportUrl,
        contactEmail: contactEmail,
        hasLightSensor: hasLightSensor ?? this.hasLightSensor,
      );
}
