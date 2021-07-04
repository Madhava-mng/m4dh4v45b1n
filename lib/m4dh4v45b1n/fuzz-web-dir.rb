require_relative 'version'
require_relative 'rand-util'
require 'json'
require 'net/http';
def wordlist
  Gem::path.map do |p|
    if File.exist? p+"/gems/m4dh4v45b1n-#{VERSION}/dict/dirs.txt"
      return p+"/gems/m4dh4v45b1n-#{VERSION}/dict/dirs.txt"
    end
  end
  puts "fuzz-web-dir.rb: Unable to deduct default wordlist use -w"
  exit
end
FUZZ_WEB_DIR_DICT= wordlist
FUZZ_WEB_DIR_HIDE_CODE=['404']
FUZZ_WEB_DIR_EXT = ['php', 'txt', 'html', 'xml']
FUZZ_WEB_DIR_HEADER = '{}'
FUZZ_WEB_DIR_TIMEOUT = 1    # SECONDS
FUZZ_WEB_DIR_MAX_THREAD = 24
FUZZ_WEB_DIR_WAIT = 0
=begin
var = Fuzz_web_dir::new
var.url = "http://example.com"  *
var.hide_*  type  object
var.hide_/code/line/char
var show_/code/line/char
var.dict = custom_dict.txt
var.timeout = 5
var.max_thread = 24
var.ext = ['php','txt']
=end
class Fuzz_web_dir
  attr_accessor :url,:dict,:hide_code,:hide_line,:hide_char,:show_code,:show_line,:show_char,:timeout,:max_thread,:ext,:out,:wait
  def initialize()
    @dict = FUZZ_WEB_DIR_DICT
    @hide_code = FUZZ_WEB_DIR_HIDE_CODE
    @hide_char = []
    @hide_line = []
    @show_code = []
    @show_char = []
    @show_line = []
    @timeout = FUZZ_WEB_DIR_TIMEOUT
    @max_thread = FUZZ_WEB_DIR_MAX_THREAD
    @header = FUZZ_WEB_DIR_HEADER
    @ext = FUZZ_WEB_DIR_EXT
    @wait = FUZZ_WEB_DIR_WAIT
  end
  def show_result(url_)
    begin
      @header['User-Agent'] = rand_user_agent
      res_ = Net::HTTP::get_response(URI(url_), @header)
      line_ = res_.body.split("\n").length
      char_ = res_.body.length
      code_ = res_.code
      put_it = true
      if (@hide_code.include? code_);put_it = false;end
      if (@hide_char.include? char_);put_it = false;end
      if (@hide_line.include? line_);put_it = false;end
      if (@show_code.include? code_);put_it = true;end
      if (@show_char.include? char_);put_it = true;end
      if (@show_line.include? line_);put_it = true;end
      #if (code_ == '301' and char_ == 0 and line_ == 0);url_ += "/";end
      if put_it
        puts "\r\e[32m#{url_}\e[0m  lines:\e[33m#{line_}\e[0m chrs:\e[35m#{char_}\e[0m status:\e[36m#{code_}\e[0m"
        if !@out.nil?
          @out.write(url_ + "\n")
        end
      end
    rescue (Errno::ECONNREFUSED) => e
      print "\rConnectionFailed:Unable to connect..."
    rescue Interrupt => e
      Thread::list::map do |t|
        Thread::kill t
      end
    rescue => e
      print "\rInvalideURL: #{@url}   "
    end
  end
  def print_status(key,  val)
    puts "\e[32m#{key.upcase}\e[0m: #{val}."
  end
  def print_status_all
    [
      ["target", @url],
      ["dict", @dict],
      ["ext", @ext[0,@ext.length-1].map{|e| e[1,e.length]}],
      ["header", @header],
      ["User-agent", "random"],
      ["Timeout", "#{@timeout}s"],
      ["max-thread", @max_thread],
      ["pause", "#{@wait}s"],
      ["hide /status/line/char", "#{@hide_code}/#{@hide_line}/#{@hide_char}"],
      ["show /status/line/char", "#{@show_code}/#{@show_line}/#{@show_char}"],
      ["output", @out]
    ].map {|k,v| print_status(k, v)}
    puts "-"*45
  end
  def check_it
    if @url[-1] != '/'
      @url += '/'
    end
    @ext = @ext.map {|i| '.'+i }
    @ext.append("")
    @header = JSON::parse(@header)
    print_status_all
    if !@out.nil?
      @out = File.open(@out, "w")
    end
  end
  def fuzz
    check_it
    # read dict file
    File::open(@dict, "r") do |line|
      while true
        string_line = line.readline
        @ext.map do |ext|
          Thread::new do
            begin
              Timeout::timeout(@timeout) do
                if string_line[0] != "#"
                  show_result(@url+URI::encode_www_form_component(string_line.chomp+ext))
                end
              end
            rescue (Timeout::Error) => e
            rescue (EOFError) => e
              break
            end
          end
          while Thread::list.length > @max_thread;end
          sleep(0.01 + @wait)
        end
        if string_line.length < 20
          print "\r#{' '*50}\r> #{string_line.chomp}"
        end
      end
    end
  end
end
