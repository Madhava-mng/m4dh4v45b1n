#!/bin/env ruby

require 'm4dh4v45b1n'
require 'optparse'


def  main
  init = Fuzz_web_dir::new()
  OptionParser.new do |optp|
    optp.banner = "\nUsage: fuzz-web-dir.rb [-h] [-w DICT] [-t MAXTHREAD] [..] URL
des: Directory fuzzer. (#{VERSION})
recomended: ruby-3.x.x otherwise it won't work properly.
Eg: fuzz-web-dir.rb -e php,txt --hs 303,404  https://example.com
    fuzz-web-dir.rb -u http://example.com/ -w num.txt -H '{\"foo\":\"bar\"}'\n\n"
    optp.program_name = "fuzz-web-dir"
    optp.summary_width = 12
    optp.program_name = "fuzz-web-dir"
    optp.version = VERSION

    optp.on('-w FILE', "Use custom wordlist. ","(default:#{FUZZ_WEB_DIR_DICT})\n") do |w|
      init.dict = w
    end
    optp.on('-e EXT', "Add extension.","Use comma for multiple value.", "(default:txt,php,html,xml") do |w|
      init.ext = w.split(',')
    end
    optp.on('-E', "Dissable extension search.") do |e|
      init.use_ext = false
    end
    optp.on('-p INT', Float, 'Pause the fuzz for N second.') do |p|
      init.wait = p
    end
    optp.on('-d' , "Enable decoy for evate the fire wall.","add #{FUZZ_WEB_DIR_PROXY_FILE},","for default decoy list. x.x.x.x:p format.") do |d|
      init.decoy = true
    end
    optp.on('-D FILE' , "Use decoy file.") do |d|
      init.decoy = true
      init.pfile = d
    end
    optp.on('-n', 'Run decoy with out checking it.',"It may affect the result.\n") do
      init.check = false
    end
    optp.on('-f', "Follow redirection") do |f|
      init.follow = true
    end
    optp.on('-t INT', Integer, "Maximum concurrency. (default:#{FUZZ_WEB_DIR_MAX_THREAD})\n") do |t|
      init.max_thread = t
    end
    optp.on('-T INT', Float, "Set time out for each try. (default:#{FUZZ_WEB_DIR_TIMEOUT}s)\n") do|t|
      init.timeout = t
    end
    optp.on('-u URL', "Target url or specify without -u flag.\n")do|u|
      init.url = u
    end
    optp.on('-o FILE', "Write output to the file.")do|f|
      init.out = f
    end
    optp.on('-H HEAD', 'Add header in json format with in apostrophy.',' eg:\'{"key":29}\' .') do |h|
      init.header = h
    end
    optp.on('-s INT', '--hs', "Hide status code. Use comma for multiple value. ","(default:404)") do |hc|
      init.hide_code = hc.split(',')
    end
    optp.on('-c INT', '--hc', "Hide No.Of.Chars. Use comma for multiple value. ") do |hc|
      init.hide_char = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-l INT', '--hl', "Hide No.of.Lines. Use comma for multiple value. ") do |hc|
      init.hide_line = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-S INT', '--ss', "Show status code. Use comma for multiple value.") do |hc|
      init.show_code = hc.split(',')
    end
    optp.on('-C INT', '--sc', "Show No.Of.Chars. Use comma for multiple value. ") do |hc|
      init.show_char = hc.split(',').map {|e| e.to_i}
    end
    optp.on('-L INT', '--sl', "Show No.of.Lines. Use comma for multiple value. ") do |hc|
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
