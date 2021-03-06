#!/bin/env ruby

require 'm4dh4v45b1n'
require 'optparse'


def  main
  init = Subdomain_enum::new()
  OptionParser.new do |optp|
    optp.banner = "\nUsage: enum-subdomain.rb [-h] [-v] [-w DICT] [-t MAXTHREAD] [-T TIMEOUT] [-o OUT] DOMAIN
des: enumarate subdomain with randomize dns. (#{VERSION})
ability: Once It get the subdomain via R(dns).
         It never enumarate again if you don't use '-C' flag.
         The data logs under ~/.cache/enum-subdomain/.
Eg: enum-subdomain.rb -v example.com\n\n"
    optp.program_name = "enum-subdomain"
    optp.summary_width = 14
    optp.program_name = "enum-subdomain"
    optp.version = VERSION

    optp.on('-v', 'Enable verbose mode.') do |v|
      init.verbose = v
    end
    optp.on('-t MAXTHREAD', Integer, "Maximum concurrency. (default:#{MAX_THREAD})") do |t|
      init.max_thread = t
    end
    optp.on('-w WORDLIST', "Use custom wordlist. (default:#{WORDLIST})") do |w|
      init.wordlist = w
    end
    optp.on('-T TIMEOUT', Integer, "Set time out for each try. (default:#{TIME_OUT}s)") do|t|
      init.timeout = t
    end
    optp.on('-o OUTPUT', "Append output to the file.")do|f|
      init.out = f
    end
    optp.on('-c', "Show cached subdomain and exit.") do|f|
      init.show_cache = true
    end
    optp.on('-C', "Ignore cached subdomain and enumarate again.")do |c|
      init.show_cache_without_d = false
      init.show_new = false
    end
    optp.on('-n', "Hide cached subdomain and show only new.") do |n|
      init.show_new = false
    end
    optp.on('-h', '--help', "Print this help banner.") do |h|
      puts optp
      exit
    end
  end.parse!
  init.target = ARGV[-1]
  if !init.target.nil?
    init.brut
  else
    puts "enum-subdomain.rb:OptionRequire: use -h or --help."
  end
end


begin
  main
rescue (OptionParser::MissingArgument) => e
  puts e
rescue (OptionParser::InvalidArgument) => e
  puts e
rescue (Interrupt) => e
  puts "\e[1A\e[C"
end
