# $Id$
#
#
#----------------------------------------------------------------------------
#
# Copyright (C) 2006 by Francis Cianfrocca. All Rights Reserved.
#
# Gmail: garbagecat10
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#---------------------------------------------------------------------------
#
#


module Net
class LDAP


# Class Net::LDAP::Filter is used to constrain
# LDAP searches. An object of this class is
# passed to Net::LDAP#search in the parameter :filter.
#
# Net::LDAP::Filter supports the complete set of search filters
# available in LDAP, including conjunction, disjunction and negation
# (AND, OR, and NOT). This class supplants the (infamous) RFC-2254
# standard notation for specifying LDAP search filters.
#
# Here's how to code the familiar "objectclass is present" filter:
#  f = Net::LDAP::Filter.pres( "objectclass" )
# The object returned by this code can be passed directly to
# the <tt>:filter</tt> parameter of Net::LDAP#search.
#
# See the individual class and instance methods below for more examples.
#
class Filter

  def initialize op, a, b
    @op = op
    @left = a
    @right = b
  end

  class << self
    ##
    # Creates a Filter object indicating that the value of a particular
    # attribute must either be present or match a particular string.
    #
    # Specifying that an attribute is 'present' means only directory entries
    # which contain a value for the particular attribute will be selected by
    # the filter. This is useful in case of optional attributes such as
    # <tt>mail.</tt> Presence is indicated by giving the value "*" in the
    # second parameter to #eq. This example selects only entries that have
    # one or more values for <tt>sAMAccountName:</tt>
    #
    # f = Net::LDAP::Filter.eq("sAMAccountName", "*")
    #
    # To match a particular range of values, pass a string as the second
    # parameter to #eq. The string may contain one or more "*" characters as
    # wildcards: these match zero or more occurrences of any character. Full
    # regular-expressions are <i>not</i> supported due to limitations in the
    # underlying LDAP protocol. This example selects any entry with a
    # <tt>mail</tt> value containing the substring "anderson":
    #
    # f = Net::LDAP::Filter.eq("mail", "*anderson*")
    def eq(attribute, value)
      new(:eq, attribute, value)
    end

    ##
    # Creates a Filter object indicating extensible comparison. This Filter
    # object is currently considered EXPERIMENTAL.
    #
    # sample_attributes = ['cn:fr', 'cn:fr.eq',
    # 'cn:1.3.6.1.4.1.42.2.27.9.4.49.1.3', 'cn:dn:fr', 'cn:dn:fr.eq']
    # attr = sample_attributes.first # Pick an extensible attribute
    # value = 'roberts'
    #
    # filter = "#{attr}:=#{value}" # Basic String Filter
    # dc: example
    #
    # dn: ou=People,dc=example,dc=com
    # objectClass: organizationalUnit
    # objectClass: top
    # ou: People
    #
    # dn: uid=1,ou=People,dc=example,dc=com
    # objectClass: person
    # objectClass: organizationalPerson
    # objectClass: inetOrgPerson
    # objectClass: top
    # cn:: csO0YsOpcnRz
    # sn:: YsO0YiByw7Riw6lydHM=
    # givenName:: YsO0Yg==
    # uid: 1
    #
    # =Refs:
    # * http://www.ietf.org/rfc/rfc2251.txt
    # * http://www.novell.com/documentation/edir88/edir88/?page=/documentation/edir88/edir88/data/agazepd.html
    # * https://docs.opends.org/2.0/page/SearchingUsingInternationalCollationRules
    #++
    def ex(attribute, value)
      new(:ex, attribute, value)
    end

    ##
    # Creates a Filter object indicating that a particular attribute value
    # is either not present or does not match a particular string; see
    # Filter::eq for more information.
    def ne(attribute, value)
      new(:ne, attribute, value)
    end

    ##
    # Creates a Filter object indicating that a particular attribute value
    # is greater than or equal to the specified value.
    def ge(attribute, value)
      new(:ge, attribute, value)
    end

    ##
    # Creates a Filter object indicating that a particular attribute value
    # is less than or equal to the specified value.
    def le(attribute, value)
      new(:le, attribute, value)
    end

    ##
    # Joins two or more filters so that all conditions must be true. Calling
    # <tt>Filter.join(left, right)</tt> is the same as <tt>left &
    # right</tt>.
    #
    # # Selects only entries that have an <tt>objectclass</tt> attribute.
    # x = Net::LDAP::Filter.present("objectclass")
    # # Selects only entries that have a <tt>mail</tt> attribute that begins
    # # with "George".
    # y = Net::LDAP::Filter.eq("mail", "George*")
    # # Selects only entries that meet both conditions above.
    # z = Net::LDAP::Filter.join(x, y)
    def join(left, right)
      Filter.new(:and, left, right)
    end

    ##
    # Creates a disjoint comparison between two or more filters. Selects
    # entries where either the left or right side are true. Calling
    # <tt>Filter.intersect(left, right)</tt> is the same as <tt>left |
    # right</tt>.
    #
    # # Selects only entries that have an <tt>objectclass</tt> attribute.
    # x = Net::LDAP::Filter.present("objectclass")
    # # Selects only entries that have a <tt>mail</tt> attribute that begins
    # # with "George".
    # y = Net::LDAP::Filter.eq("mail", "George*")
    # # Selects only entries that meet either condition above.
    # z = x | y
    def intersect(left, right)
      Filter.new(:or, left, right)
    end

    ##
    # Negates a filter. Calling <tt>Fitler.negate(filter)</tt> i s the same
    # as <tt>~filter</tt>.
    #
    # # Selects only entries that do not have an <tt>objectclass</tt>
    # # attribute.
    # x = ~Net::LDAP::Filter.present("objectclass")
    def negate(filter)
      Filter.new(:not, filter, nil)
    end

    ##
    # This is a synonym for #eq(attribute, "*"). Also known as #present and
    # #pres.
    def present?(attribute)
      Filter.eq(attribute, "*")
    end

    alias_method :present, :present?
    alias_method :pres, :present?
  end

  # operator & ("AND") is used to conjoin two or more filters.
  # This expression will select only entries that have an <tt>objectclass</tt>
  # attribute AND have a <tt>mail</tt> attribute that begins with "George":
  #  f = Net::LDAP::Filter.pres( "objectclass" ) & Net::LDAP::Filter.eq( "mail", "George*" )
  #
  def & filter; Filter.new :and, self, filter; end

  # operator | ("OR") is used to disjoin two or more filters.
  # This expression will select entries that have either an <tt>objectclass</tt>
  # attribute OR a <tt>mail</tt> attribute that begins with "George":
  #  f = Net::LDAP::Filter.pres( "objectclass" ) | Net::LDAP::Filter.eq( "mail", "George*" )
  #
  def | filter; Filter.new :or, self, filter; end

  #
  # operator ~ ("NOT") is used to negate a filter.
  # This expression will select only entries that <i>do not</i> have an <tt>objectclass</tt>
  # attribute:
  #  f = ~ Net::LDAP::Filter.pres( "objectclass" )
  #
  #--
  # This operator can't be !, evidently. Try it.
  # Removed GT and LT. They're not in the RFC.
  def ~@; Filter.new :not, self, nil; end

  	# Equality operator for filters, useful primarily for constructing unit tests.
	def == filter
		str = "[@op,@left,@right]"
		self.instance_eval(str) == filter.instance_eval(str)
	end

  def to_raw_rfc2254
    case @op
    when :ne
      "!(#{@left}=#{@right})"
    when :eq
      "#{@left}=#{@right}"
   when :ex
      "#{@left}:=#{@right}"
    #when :gt
     # "#{@left}>#{@right}"
    #when :lt
     # "#{@left}<#{@right}"
    when :ge
      "#{@left}>=#{@right}"
    when :le
      "#{@left}<=#{@right}"
    when :and
      "&(#{@left.__send__(:to_raw_rfc2254)})(#{@right.__send__(:to_raw_rfc2254)})"
    when :or
      "|(#{@left.__send__(:to_raw_rfc2254)})(#{@right.__send__(:to_raw_rfc2254)})"
    when :not
      "!(#{@left})"
    else
      "!(#{@left.__send__(:to_raw_rfc2254)})"
    end
  end

  private :to_raw_rfc2254

  ##
  # Converts the Filter object to an RFC 2254-compatible text format.
  def to_rfc2254
    "(#{to_raw_rfc2254})"
  end

  def to_s
    to_rfc2254
  end

  #--
  # to_ber
  # Filter ::=
  #     CHOICE {
  #         and             [0] SET OF Filter,
  #         or              [1] SET OF Filter,
  #         not             [2] Filter,
  #         equalityMatch   [3] AttributeValueAssertion,
  #         substrings      [4] SubstringFilter,
  #         greaterOrEqual  [5] AttributeValueAssertion,
  #         lessOrEqual     [6] AttributeValueAssertion,
  #         present         [7] AttributeType,
  #         approxMatch     [8] AttributeValueAssertion,
  #         extensibleMatch [9] MatchingRuleAssertion
  #     }
  #
  # SubstringFilter ::=
  #     SEQUENCE {
  #         type               AttributeType,
  #         SEQUENCE OF CHOICE {
  #             initial        [0] LDAPString,
  #             any            [1] LDAPString,
  #             final          [2] LDAPString
  #         }
  #     }
  #
  # MatchingRuleAssertion ::=
  #     SEQUENCE {
  #       matchingRule    [1] MatchingRuleId OPTIONAL,
  #       type            [2] AttributeDescription OPTIONAL,
  #       matchValue      [3] AssertionValue,
  #       dnAttributes    [4] BOOLEAN DEFAULT FALSE
  #     }
  #     
  # Matching Rule Suffixes
  #     Less than	 [.1] or .[lt]
  #     Less than or equal to	[.2] or [.lte]
  #     Equality	[.3] or	[.eq] (default)
  #     Greater than or equal to	[.4] or [.gte]
  #     Greater than	[.5] or [.gt]
  #     Substring	[.6] or	[.sub]
  #
  # Parsing substrings is a little tricky.
  # We use the split method to break a string into substrings
  # delimited by the * (star) character. But we also need
  # to know whether there is a star at the head and tail
  # of the string. A Ruby particularity comes into play here:
  # if you split on * and the first character of the string is
  # a star, then split will return an array whose first element
  # is an _empty_ string. But if the _last_ character of the
  # string is star, then split will return an array that does
  # _not_ add an empty string at the end. So we have to deal
  # with all that specifically.
  #
  def to_ber
    case @op
    when :eq
      if @right == "*"          # present
        @left.to_s.to_ber_contextspecific 7
      elsif @right =~ /[\*]/    #substring
        ary = @right.split( /[\*]+/ )
        final_star = @right =~ /[\*]$/
        initial_star = ary.first == "" and ary.shift

        seq = []
        unless initial_star
          seq << ary.shift.to_ber_contextspecific(0)
        end
        n_any_strings = ary.length - (final_star ? 0 : 1)
        #p n_any_strings
        n_any_strings.times {
          seq << ary.shift.to_ber_contextspecific(1)
        }
        unless final_star
          seq << ary.shift.to_ber_contextspecific(2)
        end
        [@left.to_s.to_ber, seq.to_ber].to_ber_contextspecific 4
      else                      #equality
        [@left.to_s.to_ber, unescape(@right).to_ber].to_ber_contextspecific 3
      end
    when :ex
      seq = []

      unless @left =~ /^([-;\d\w]*)(:dn)?(:(\w+|[.\d\w]+))?$/
        raise "Bad attribute #{@left}"
      end
      type, dn, rule = $1, $2, $4

      seq << rule.to_ber_contextspecific(1) unless rule.to_s.empty? # matchingRule
      seq << type.to_ber_contextspecific(2) unless type.to_s.empty? # type
      seq << unescape(@right).to_ber_contextspecific(3) # matchingValue
      seq << "1".to_ber_contextspecific(4) unless dn.to_s.empty? # dnAttributes

      seq.to_ber_contextspecific 9
    when :ge
      [@left.to_s.to_ber, unescape(@right).to_ber].to_ber_contextspecific 5
    when :le
      [@left.to_s.to_ber, unescape(@right).to_ber].to_ber_contextspecific 6
    when :and
      ary = [@left.coalesce(:and), @right.coalesce(:and)].flatten
      ary.map {|a| a.to_ber}.to_ber_contextspecific( 0 )
    when :or
      ary = [@left.coalesce(:or), @right.coalesce(:or)].flatten
      ary.map {|a| a.to_ber}.to_ber_contextspecific( 1 )
    when :ne
      [Net::LDAP::Filter.eq(@left, @right).to_ber].to_ber_contextspecific 2
    when :not
        [@left.to_ber].to_ber_contextspecific 2
    else
      # ERROR, we'll return objectclass=* to keep things from blowing up,
      # but that ain't a good answer and we need to kick out an error of some kind.
      raise "unimplemented search filter"
    end
  end

  def unescape(right)
    right.gsub(/\\([a-fA-F\d]{2,2})/) do
      [$1.hex].pack("U")
    end
  end


	# Converts an LDAP search filter in BER format to an Net::LDAP::Filter
	# object. The incoming BER object most likely came to us by parsing an
	# LDAP searchRequest PDU.
	# Cf the comments under #to_ber, including the grammar snippet from the RFC.
	#--
	# We're hardcoding the BER constants from the RFC. Ought to break them out
	# into constants.
	#
	def Filter::parse_ber ber
		case ber.ber_identifier
		when 0xa0 # context-specific constructed 0, "and"
			ber.map {|b| Filter::parse_ber(b)}.inject {|memo,obj| memo & obj}
		when 0xa1 # context-specific constructed 1, "or"
			ber.map {|b| Filter::parse_ber(b)}.inject {|memo,obj| memo | obj}
		when 0xa2 # context-specific constructed 2, "not"
			~ Filter::parse_ber( ber.first )
		when 0xa3 # context-specific constructed 3, "equalityMatch"
			if ber.last == "*"
			else
				Filter.eq( ber.first, ber.last )
			end
		when 0xa4 # context-specific constructed 4, "substring"
			str = ""
			final = false
			ber.last.each {|b|
				case b.ber_identifier
				when 0x80 # context-specific primitive 0, SubstringFilter "initial"
					raise "unrecognized substring filter, bad initial" if str.length > 0
					str += b
				when 0x81 # context-specific primitive 0, SubstringFilter "any"
					str += "*#{b}"
				when 0x82 # context-specific primitive 0, SubstringFilter "final"
					str += "*#{b}"
					final = true
				end
			}
			str += "*" unless final
			Filter.eq( ber.first.to_s, str )
		when 0xa5 # context-specific constructed 5, "greaterOrEqual"
			Filter.ge( ber.first.to_s, ber.last.to_s )
		when 0xa6 # context-specific constructed 5, "lessOrEqual"
			Filter.le( ber.first.to_s, ber.last.to_s )
		when 0x87 # context-specific primitive 7, "present"
			# call to_s to get rid of the BER-identifiedness of the incoming string.
			Filter.pres( ber.to_s )
		else
			raise "invalid BER tag-value (#{ber.ber_identifier}) in search filter"
		end
	end


	# Perform filter operations against a user-supplied block. This is useful when implementing
	# an LDAP directory server. The caller's block will be called with two arguments: first, a
	# symbol denoting the "operation" of the filter; and second, an array consisting of arguments
	# to the operation. The user-supplied block (which is MANDATORY) should perform some desired
	# application-defined processing, and may return a locally-meaningful object that will appear
	# as a parameter in the :and, :or and :not operations detailed below.
	#
	# A typical object to return from the user-supplied block is an array of
	# Net::LDAP::Filter objects.
	#
	# These are the possible values that may be passed to the user-supplied block:
	#  :equalityMatch (the arguments will be an attribute name and a value to be matched);
	#  :substrings (two arguments: an attribute name and a value containing one or more * characters);
	#  :present (one argument: an attribute name);
	#  :greaterOrEqual (two arguments: an attribute name and a value to be compared against);
	#  :lessOrEqual (two arguments: an attribute name and a value to be compared against);
	#  :and (two or more arguments, each of which is an object returned from a recursive call
	#     to #execute, with the same block;
	#  :or (two or more arguments, each of which is an object returned from a recursive call
	#     to #execute, with the same block;
	#  :not (one argument, which is an object returned from a recursive call to #execute with the
	#     the same block.
	#
	def execute &block
		case @op
		when :eq
			if @right == "*"
				yield :present, @left
			elsif @right.index '*'
				yield :substrings, @left, @right
			else
				yield :equalityMatch, @left, @right
			end    
		when :ge
			yield :greaterOrEqual, @left, @right
		when :le
			yield :lessOrEqual, @left, @right
		when :or, :and
			yield @op, (@left.execute(&block)), (@right.execute(&block))
		when :not
			yield @op, (@left.execute(&block))
		end || []
	end


  #--
  # coalesce
  # This is a private helper method for dealing with chains of ANDs and ORs
  # that are longer than two. If BOTH of our branches are of the specified
  # type of joining operator, then return both of them as an array (calling
  # coalesce recursively). If they're not, then return an array consisting
  # only of self.
  #
  def coalesce operator
    if @op == operator
      [@left.coalesce( operator ), @right.coalesce( operator )]
    else
      [self]
    end
  end



  #--
  # We get a Ruby object which comes from parsing an RFC-1777 "Filter"
  # object. Convert it to a Net::LDAP::Filter.
  # TODO, we're hardcoding the RFC-1777 BER-encodings of the various
  # filter types. Could pull them out into a constant.
  #
  def Filter::parse_ldap_filter obj
    case obj.ber_identifier
    when 0x87         # present. context-specific primitive 7.
      Filter.eq( obj.to_s, "*" )
    when 0xa3         # equalityMatch. context-specific constructed 3.
      Filter.eq( obj[0], obj[1] )
    else
      raise LdapError.new( "unknown ldap search-filter type: #{obj.ber_identifier}" )
    end
  end




  #--
  # We got a hash of attribute values.
  # Do we match the attributes?
  # Return T/F, and call match recursively as necessary.
  def match entry
    case @op
    when :eq
      if @right == "*"
        l = entry[@left] and l.length > 0
      else
        l = entry[@left] and l = l.to_a and l.index(@right)
      end
    else
      raise LdapError.new( "unknown filter type in match: #{@op}" )
    end
  end

  # Converts an LDAP filter-string (in the prefix syntax specified in RFC-2254)
  # to a Net::LDAP::Filter.
  def self.construct ldap_filter_string
    FilterParser.new(ldap_filter_string).filter
  end

  # Synonym for #construct.
  # to a Net::LDAP::Filter.
  def self.from_rfc2254 ldap_filter_string
    construct ldap_filter_string
  end

end # class Net::LDAP::Filter



class FilterParser #:nodoc:

  attr_reader :filter

  def initialize str
    require 'strscan'
    @filter = parse( StringScanner.new( str )) or raise Net::LDAP::LdapError.new( "invalid filter syntax" )
  end

  def parse scanner
    parse_filter_branch(scanner) or parse_paren_expression(scanner)
  end

  def parse_paren_expression scanner
    if scanner.scan(/\s*\(\s*/)
      b = if scanner.scan(/\s*\&\s*/)
        a = nil
        branches = []
        while br = parse_paren_expression(scanner)
          branches << br
        end
        if branches.length >= 2
          a = branches.shift
          while branches.length > 0
            a = a & branches.shift
          end
          a
        end
      elsif scanner.scan(/\s*\|\s*/)
        # TODO: DRY!
        a = nil
        branches = []
        while br = parse_paren_expression(scanner)
          branches << br
        end
        if branches.length >= 2
          a = branches.shift
          while branches.length > 0
            a = a | branches.shift
          end
          a
        end
      elsif scanner.scan(/\s*\!\s*/)
        br = parse_paren_expression(scanner)
        if br
          ~ br
        end
      else
        parse_filter_branch( scanner )
      end

      if b and scanner.scan( /\s*\)\s*/ )
        b
      end
    end
  end

  # Added a greatly-augmented filter contributed by Andre Nathan
  # for detecting special characters in values. (15Aug06)
  # Added blanks to the attribute filter (26Oct06)
  def parse_filter_branch scanner
    scanner.scan(/\s*/)
    if token = scanner.scan( /[\d\w\-_\:\.]*[\d\w]/ )
      scanner.scan(/\s*/)
      if op = scanner.scan( /\=|\:\=|\<\=|\<|\>\=|\>|\!\=/ )
        scanner.scan(/\s*/)
        if value = scanner.scan( /(?:[\w\*\.\+\-@=,#\$%&! ]|\\[a-fA-F\d]{2,2})+/ )
          case op
          when "="
            Filter.eq( token, value )
          when ":="
            Filter.ex( token, value )
          when "!="
            Filter.ne( token, value )
          when "<"
            Filter.lt( token, value )
          when "<="
            Filter.le( token, value )
          when ">"
            Filter.gt( token, value )
          when ">="
            Filter.ge( token, value )
          end
        end
      end
    end
  end

end # class Net::LDAP::FilterParser

end # class Net::LDAP
end # module Net


