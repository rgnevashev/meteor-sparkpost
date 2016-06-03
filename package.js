Package.describe({
  name: 'rgnevashev:sparkpost',
  version: '1.0.3',
  summary: 'A Node.js wrapper for interfacing with your favorite SparkPost APIs',
  git: 'https://github.com/rgnevashev/meteor-sparkpost.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use(['email', 'http', 'underscore'], ['server']);
  api.use('coffeescript');
  api.addFiles(['sparkpost.coffee','global_variables.js'], 'server');
  api.export('SparkPost');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('rgnevashev:sparkpost');
  api.addFiles('sparkpost-tests.js');
});
