# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'rcov/rcovtask'
require 'rake/clean'
require File.join(File.dirname(__FILE__), 'lib', 'uri', 'version')

gem 'ci_reporter'
require 'ci/reporter/rake/test_unit' # use this if you're using Test::Unit

class Hoe
  def extra_deps 
    @extra_deps.reject { |x| Array(x).first == 'hoe' } 
  end 
end

# clean files and directories
CLEAN.include ['**/.*.sw?', '*.gem', '.config', 'coverage']

Hoe.new('uri-templates', UriTemplate::VERSION::STRING) do |p|
  p.rubyforge_name = 'uri-templates'
  p.author = 'Stefan Saasen'
  p.email = 's@juretta.com'
  p.need_tar = false
  p.clean_globs = CLEAN
  p.rsync_args << " -z"  
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  #p.spec_extras = {:dependencies => []}   # - A hash of extra values to set in the gemspec.
  p.remote_rdoc_dir = ''
  p.extra_deps = [['treetop', '>=1.2.3']]
end

desc "Create the UriTemplate parser from the Treetop grammar"
task :generate_parser do
  sh 'tt grammar/uri_template.treetop -o lib/uri/grammar.rb'
end

#task :test => [:generate_parser]

desc "Run basic unit tests"
Rake::TestTask.new("test_unit") { |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
  t.warning = true
}

desc 'Measures test coverage'
Rcov::RcovTask.new("coverage") do |t|
  t.test_files = FileList['test/test_*.rb']
  t.verbose = false
  t.rcov_opts << "--test-unit-only"
  t.ruby_opts << "-Ilib:ext/rcovrt" # in order to use this rcov
  t.output_dir = "coverage"
end

# vim: syntax=Ruby
