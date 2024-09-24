Gem::Specification.new do |s|
  s.name        = 'namecheap-client'
  s.version     = '0.1.2'
  s.date        = '2024-09-23'
  s.summary     = "A simple Ruby client library for interacting with the [Namecheap API](https://www.namecheap.com/support/api/intro/), allowing you to manage your domains programmatically."
  s.description = "A simple Ruby client library for interacting with the [Namecheap API](https://www.namecheap.com/support/api/intro/), allowing you to manage your domains programmatically."
  s.authors     = ["Leandro Daniel Sardi"]
  s.email       = 'leandro@massprospecting.com'
  s.files       = [
    "lib/namecheap-client.rb",
  ]
  s.homepage    = 'https://rubygems.org/gems/namecheap-client'
  s.license     = 'MIT'
  s.add_runtime_dependency 'net-http', '~> 0.2.2'
  s.add_runtime_dependency 'uri', '~> 0.11.2'
  s.add_runtime_dependency 'nokogiri', '~> 0.13.10' 
end