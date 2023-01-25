class Environment {
  final String sourceCodeUrl;
  final String issuesReportUrl;
  final String contactEmail;

  const Environment({
    required this.sourceCodeUrl,
    required this.issuesReportUrl,
    required this.contactEmail,
  });

  const Environment.dev()
      : sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues',
        contactEmail = 'contact.vodemn@gmail.com';

  const Environment.prod()
      : sourceCodeUrl = 'https://github.com/vodemn/m3_lightmeter',
        issuesReportUrl = 'https://github.com/vodemn/m3_lightmeter/issues',
        contactEmail = 'contact.vodemn@gmail.com';
}
