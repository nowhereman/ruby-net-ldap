# -*- ruby -*-

require 'rubygems'

# Add 'lib' to load path.
$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/lib" )

# Pull in local 'net/ldap' as opposed to an installed version.
require 'net/ldap'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "my-ruby-net-ldap"
    gemspec.summary = "Pure Ruby LDAP library"
    gemspec.email = "contact@dvisionfactory.com"
    gemspec.homepage = "http://github.com/nowhereman/ruby-net-ldap"
    gemspec.rubyforge_project = "net-ldap"
    gemspec.description = "Net::LDAP is a feature-complete LDAP support library written in pure Ruby. It supports most LDAP client features and a subset of server features as well."
    gemspec.authors = ["Francis Cianfrocca", "Emiel van de Laar", "Tom Copeland", "Austin Ziegler", "Dimitrij Denissenko" "Nowhere Man"]
    gemspec.test_files = Dir.glob('test*/**')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# vim: syntax=Ruby
