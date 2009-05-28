# -*- ruby -*-

require 'rubygems'
require 'hoe'

# Add 'lib' to load path.
$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/lib" )

# Pull in local 'net/ldap' as opposed to an installed version.
require 'net/ldap'

Hoe.new('ruby-net-ldap', Net::LDAP::VERSION) do |p|
  p.developer('Francis Cianfrocca', 'garbagecat10@gmail.com')
  p.developer('Emiel van de Laar', 'gemiel@gmail.com')
end

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
