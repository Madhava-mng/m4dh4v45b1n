require_relative 'version'
require_relative 'rand-util'
require 'json'
require 'openssl'
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
FUZZ_WEB_DIR_TIMEOUT = 3    # SECONDS
FUZZ_WEB_DIR_MAX_THREAD = 24
FUZZ_WEB_DIR_WAIT = 0
FUZZ_WEB_DIR_PROXY_FILE = "#{ENV['HOME']}/.proxies.txt"
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
  attr_accessor :url,:dict,:hide_code,:hide_line,:hide_char,:show_code,:show_line,:show_char,:timeout,:max_thread,:ext,:out,:wait,:proxy,:decoy,:last_decoy, :pfile,:check,:header,:follow
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
    @decoy = false
    @check = true
    @follow = false
    @last_decoy = ''
    @pfile = FUZZ_WEB_DIR_PROXY_FILE
  end
  def show_result(url_, try_ = 5)
    begin
      @header['User-Agent'] = rand_user_agent
      protocol = URI(url_).scheme
      if @decoy
        proxy_ = @last_decoy
        loop do
          proxy_ = @proxy.shuffle[0]
          if proxy_[0] != @last_decoy
            @last_decoy = proxy_[0]+":"+proxy_[1]
            break
          end
        end
        proxy = Net::HTTP::Proxy(proxy_[0],proxy_[1].to_i)
        uri = URI url_
        uri.query = @header.to_s
        req = Net::HTTP::Get::new(uri.path)
        @header.keys.map do |k|
          req[k] = @header[k]
        end
        if uri.scheme == 'https'
          res_ = proxy.start(uri.host,uri.port,:use_ssl=>true,:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|     
            http.request(req)
          end
        else
          res_ = proxy.start(uri.host,uri.port) do |http|
            http.request(req)
          end
        end
      else
        res_ = Net::HTTP::get_response(URI(url_), @header)
      end
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
      if put_it
        finally_ = "\r\e[32m#{url_}\e[0m  lines:\e[33m#{line_}\e[0m chrs:\e[35m#{char_}\e[0m status:\e[36m#{code_}\e[0m"
        if !res_.header['Location'].nil?
          finally_ += " \e[33;1m>\e[0m #{res_.header['Location']}"
        end
        puts finally_

        if !@out.nil?
          @out.write(url_ + "\n")
        end
      end
      if (@follow and !res_.header["Location"].nil?)
        tmp = res_.header["Location"]
        if URI.extract(tmp).length == 0
          tmp = url_.sub(URI(url_).path, tmp)
        end
        show_result(tmp, try_)
      end
    rescue (Errno::ECONNREFUSED) => e
      print "\r#{' '*50}\r> retrying#{'.'* try_}\r"
      if (try_ != 0)
        show_result(url_, try_ -1)
      end
    rescue (Errno::ECONNRESET) => e
      print "\r#{' '*50}\r> retrying#{'.'* try_}\r"
      if (try_ != 0)
        show_result(url_, try_ -1)
      end
    rescue (Net::HTTPRetriableError) => e
    rescue (Net::HTTPFatalError) => e
      print "\r#{' '*50}\r> retrying#{'.'* try_}\r"
      if (try_ != 0)
        show_result(url_, try_ -1)
      end
    rescue (OpenSSL::SSL::SSLError) => e
      print "#{' '*50}\r> Openssl error. use http\r"
    rescue (SocketError) => e
      print "#{' '*50}\r> Socket error. Invalide url.\r"
    rescue (Net::HTTPServerException) => e
      print "\r#{' '*50}\r> retrying#{'.'* try_}\r"
      if (try_ != 0)
        show_result(url_, try_ -1)
      end
    rescue (LocalJumpError) => e
    rescue (EOFError) => e
    rescue Interrupt => e
      Thread::list::map do |t|
        Thread::kill t
      end
    rescue => e
      print "\r#{e}\r"
      #print "\rInvalideURL: #{@url}   "
    end
  end
  def print_status(key,  val)
    puts "\e[32m#{key.capitalize.ljust(24).gsub(" ",".").gsub("_", " ")}\e[0m: #{val}"
  end
  def print_status_all
    [
      ["target", @url],
      ["dictnary", @dict],
      ["file_extension", @ext[0,@ext.length-1].map{|e| e[1,e.length]}],
      ["header", @header],
      ["User-agent", "random"],
      ["Follow_redirection", @follow],
      ["Timeout", "#{@timeout}s"],
      ["maximum_thread", @max_thread],
      ["pause_request in second", "#{@wait}s"],
      ["hide_[/status/line/char]", "#{@hide_code}/#{@hide_line}/#{@hide_char}"],
      ["show_[/status/line/char]", "#{@show_code}/#{@show_line}/#{@show_char}"],
      ["output_file", @out],
      ["decoy_proxy",
       if !@proxy.nil?
         @proxy.length
       else
         0
       end
      ]
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
    if @decoy
      @proxy = Pr0xy.new.get_proxies(@pfile,  @check)
      #@proxy = [["http","127.0.0.1",8080],["http","127.0.0.2", 8081]]
    end
    print_status_all
    if !@out.nil?
      @out = File.open(@out, "w")
    end
  end
  def fuzz
    check_it
    count = 0
    # read dict file
    File::open(@dict, "r") do |line|
      while true
        string_line = line.readline
        @ext.map do |ext|
          Thread::new do
            begin
              Timeout::timeout(@timeout) do
                if string_line[0] != "#"
                  count+= 1
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
        if string_line.length > 20
          string_line = string_line[0,18] + "…"
        end
        print "\r#{' '*55}\r> #{string_line.chomp}\r"
      end
    end
  end
end
