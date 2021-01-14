# frozen_string_literal: true

Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 2.4'
  specification.name                  = 'brazilian_working_days'
  specification.version               = '0.0.2'
  specification.date                  = '2021-01-14'
  specification.summary               = 'Brazilian Working Days'
  specification.description           = 'A simple gem to count business days'
  specification.authors               = ['Arthur Ferraz', 'Flávio Peixoto']
  specification.email                 = 'arthur.ferraz07@hotmail.com'
  specification.files                 = ['lib/brazilian_working_days.rb', 'lib/data/create_json.rb', 'lib/data/json/holidays.json']
  specification.homepage              = ''
  specification.license               = 'MIT'

  # Dependencies
  specification.add_dependency 'activesupport'
  specification.add_dependency 'httparty'
  specification.add_dependency 'json'
end
