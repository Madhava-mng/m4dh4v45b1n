#!/bin/env ruby

require 'm4dh4v45b1n'
require 'optparse'


def  main
  init = Fuzz_web_dir::new()
  OptionParser.new do |optp|
    optp.banner = "\nUsage: fuzz-web-dir.rb [-h] [-w DICT] [-t MAXTHREAD] [..] URL
des: Directory fuzzer. (#{VERSION})
recomended: ruby-3.x.x otherwise it won't work properly.
Eg: fuzz-web-dir.rb -e php,txt --hc 303,404  https://example.com
    fuzz-web-dir.rb -u http://example.com/api/v2/ -D proxy/list.txt -H '{\"foo\":\"bar\"}'\n\n"
    optp.program_name = "fuzz-web-dir"
    optp.summary_width = 15
    optp.program_name = "fuzz-web-dir"
    optp.version = VERSION

    optp.on('-w WORDLIST', "Use custom wordlist. (default:#{FUZZ_WEB_DIR_DICT})") do |w|
      init.dict = w
    end
    optp.on('-e EXT', "Add extension.Use comma for multiple value. (default:txt,php,html,xml") do |w|
      init.ext = w.split(',')
    end
    optp.on('-p PAUSE', Float, 'Pause the fuzz for N second.') do |p|
      init.wait = p
    end
    optp.on('-d' , "Enable decoy for evate the fire wall. add #{FUZZ_WEB_DIR_PROXY_FILE} for default decoy list. x.x.x.x:p format.") do |d|
      init.decoy = true
    end
    optp.on('-D DECOY' , "Use decoy file.") do |d|
      init.decoy = true
      init.pfile = d
    end
    optp.on('-n', 'Run decoy with out checking it. It may affect the result.') do
      init.check = false
    end
    optp.on('-t MAXTHREAD', Integer, "Maximum concurrency. (default:#{FUZZ_WEB_DIR_MAX_THREAD})") do |t|
      init.max_thread = t
    end
    optp.on('-T TIMEOUT', Float, "Set time out for each try. (default:#{FUZZ_WEB_DIR_TIMEOUT}s)") do|t|
      init.timeout = t
    end
    optp.on('-u URL', "Target url.")do|u|
      init.url = u
    end
    optp.on('-o OUTPUT', "Write output to the file.")do|f|
      init.out = f
    end
    optp.on('-H HEAD', 'Add header in json format with in apostrophy. eg:\'{"key":29}\' .') do |h|
      init.header = h
    end
    optp.on('-s STATUS', '--hs', "Hide status code. Use comma for multiple value. (default:404)") do |hc|
      init.hide_code = hc.split(',')
    end
    optp.on('-c CHARS', '--hc', "Hide No.Of.Chars. Use comma for multiple value. ") do |hc|
      init.hide_char = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-l LINES', '--hl', "Hide No.of.Lines. Use comma for multiple value. ") do |hc|
      init.hide_line = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-S STATUS', '--ss', "Show status code. Use comma for multiple value.") do |hc|
      init.show_code = hc.split(',')
    end
    optp.on('-C CHARS', '--sc', "Show No.Of.Chars. Use comma for multiple value. ") do |hc|
      init.show_char = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-L LINES', '--sl', "Show No.of.Lines. Use comma for multiple value. ") do |hc|
      init.show_line = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-h', '--help', "Print this help banner.") do |h|
      puts optp
      exit
    end
  end.parse!
  if init.url.nil?
    init.url = ARGV[-1]
  end
  if !init.url.nil?
    init.fuzz
  else
    puts "Usage: fuzz-web-dir.rb [ARG] URL \nuse -h or --help For more info."
  end
end


begin
  main
rescue (OptionParser::MissingArgument) => e
  puts e
rescue (OptionParser::InvalidArgument) => e
  puts e
rescue (EOFError) => e
  while Thread::list.length > 1;end
  puts e
rescue (Interrupt) => e
  puts "\e[1A\e[C"
rescue => e
  puts e
end
