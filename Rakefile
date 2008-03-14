# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/uri_template/version.rb'

Hoe.new('uri_templates', UriTemplate::VERSION::STRING) do |p|
  p.rubyforge_name = 'uri_templates'
  p.author = 'Stefan Saasen'
  p.email = 's@juretta.com'
  # p.summary = 'FIX'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

desc "Create the UriTemplate parser from the Treetop grammar"
task :generate_parser do
  sh 'tt grammar/uri_template.treetop -o lib/uri_template/grammar.rb'
end

desc 'Measures test coverage'
task :coverage do
  rm_f "coverage"
  rm_f "coverage.data"
  rcov = "rcov --aggregate coverage.data --text-summary -o coverage -Ilib"
  system("#{rcov} test/test_*.rb")
  system("open coverage/index.html") if PLATFORM['darwin']
  rm_f "coverage"
end


# vim: syntax=Ruby
