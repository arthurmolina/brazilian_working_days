# frozen_string_literal: true

Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 2.4'
  specification.name                  = 'brazilian_working_days'
  specification.version               = '0.0.1'
  specification.date                  = '2021-01-14'
  specification.summary               = 'Brazilian Working Days'
  specification.description           = 'A simple gem to count business days'
  specification.authors               = ['Arthur Ferraz', 'Flávio Peixoto']
  specification.email                 = 'arthur.ferraz07@hotmail.com'
  specification.files                 = ['lib/brazilian_working_days.rb', 'lib/data/create_json.rb', 'lib/data/json/holidays.json']
  specification.homepage              = ''
  specification.license               = 'MIT'

  # Dependencies
  specification.add_dependency 'activesupport', '~> 4.2', '>= 4.2.6'
  specification.add_dependency 'httparty', '~> 0.13.7'
  specification.add_dependency 'json', '~> 1.8', '>= 1.8.3'
end
