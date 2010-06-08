# -*- ruby -*-

require 'rubygems'

# Add 'lib' to load path.
$LOAD_PATH.unshift( "#{File.dirname(__FILE__)}/lib" )

# Pull in local 'net/ldap' as opposed to an installed version.
require 'net/ldap'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "my-ruby-net-ldap"
    s.summary = "Pure Ruby LDAP library"
    s.email = "contact@dvisionfactory.com"
    s.homepage = "http://github.com/nowhereman/ruby-net-ldap"
    s.rubyforge_project = "net-ldap"
    s.description = "Net::LDAP is a feature-complete LDAP support library written in pure Ruby. It supports most LDAP client features and a subset of server features as well."
    s.authors = ["Francis Cianfrocca", "Emiel van de Laar", "Tom Copeland", "Austin Ziegler", "Dimitrij Denissenko", "Nowhere Man"]
    s.test_files = Dir.glob('test*/**')
    s.extra_rdoc_files = [
      "History.rdoc",
      "LICENSE",
      "README.rdoc",
      "COPYING"
    ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# vim: syntax=Ruby
