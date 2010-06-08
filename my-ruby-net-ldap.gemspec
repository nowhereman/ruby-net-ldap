# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{my-ruby-net-ldap}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Francis Cianfrocca", "Emiel van de Laar", "Tom Copeland", "Austin Ziegler", "Dimitrij DenissenkoNowhere Man"]
  s.date = %q{2010-06-08}
  s.description = %q{Net::LDAP is a feature-complete LDAP support library written in pure Ruby. It supports most LDAP client features and a subset of server features as well.}
  s.email = %q{contact@dvisionfactory.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.txt"
  ]
  s.files = [
    "COPYING",
     "History.txt",
     "LICENSE",
     "README.txt",
     "Rakefile",
     "VERSION.yml",
     "lib/net/ber.rb",
     "lib/net/ldap.rb",
     "lib/net/ldap/dataset.rb",
     "lib/net/ldap/entry.rb",
     "lib/net/ldap/filter.rb",
     "lib/net/ldap/pdu.rb",
     "lib/net/ldap/psw.rb",
     "lib/net/ldif.rb",
     "lib/net/snmp.rb",
     "my-ruby-net-ldap.gemspec",
     "pre-setup.rb",
     "setup.rb",
     "test/common.rb",
     "test/test_ber.rb",
     "test/test_entry.rb",
     "test/test_filter.rb",
     "test/test_ldif.rb",
     "test/test_password.rb",
     "test/test_snmp.rb",
     "test/testdata.ldif",
     "tests/NOTICE.txt",
     "tests/testldap.rb",
     "testserver/ldapserver.rb",
     "testserver/testdata.ldif"
  ]
  s.homepage = %q{http://rubyforge.org/projects/net-ldap}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Pure Ruby LDAP library}
  s.test_files = [
    "testserver/testdata.ldif",
     "testserver/ldapserver.rb",
     "tests/testldap.rb",
     "tests/NOTICE.txt",
     "test/common.rb",
     "test/test_password.rb",
     "test/testdata.ldif",
     "test/test_ber.rb",
     "test/test_snmp.rb",
     "test/test_entry.rb",
     "test/test_filter.rb",
     "test/test_ldif.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
