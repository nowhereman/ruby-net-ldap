# -*- ruby -*-

require 'rubygems'

# Add 'lib' to load path.
$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/lib" )

# Pull in local 'net/ldap' as opposed to an installed version.
require 'net/ldap'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    spec.name = "ruby-net-ldap"
    spec.summary = "Pure Ruby LDAP library"
    spec.email = "contact@dvisionfactory.com"
    spec.homepage = "http://github.com/dim/ruby-net-ldap"
    spec.description = "Net::LDAP is a feature-complete LDAP support library written in pure Ruby. It supports most LDAP client features and a subset of server features as well."
    spec.authors = ["Francis Cianfrocca", "Emiel van de Laar", "Tom Copeland", "Austin Ziegler", "Dimitrij Denissenko"]
    spec.test_files = Dir.glob('test*/**')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# vim: syntax=Ruby
