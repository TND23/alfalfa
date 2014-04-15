$:.push File.expand_path("../lib", __FILE__)
# $.push require 'lib'
Gem::Specification.new do |s|
	s.name = 'alfalfa'
	s.version = '0.1.0.pre'
	s.date = '2014-04-14'
	s.summary = 'gemfile organizer'
	s.description = 'Alfalfa can be used to alphabetize cumbersome gemfiles.'
	s.authors = ["Thomas Nast"]
	s.email = 'tommyn@isomedia.com'
	s.files = ["lib/alfalfa.rb", "lib/alfalfa/gem.rb"]
	s.homepage = 'http://rubygems.org/gems/alfalfa'
	s.license = 'MIT'
	s.rubyforge_project = "alfalfa"
	s.require_paths = ["lib"]

end