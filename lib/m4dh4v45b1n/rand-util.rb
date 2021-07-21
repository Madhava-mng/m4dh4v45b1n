require 'net/http'

PROXY_CACHE = ENV["HOME"] + "/.cache/m4dh4v45b1n/http-proxy.x7"

USER_AGENTS = [
  "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 OPR/77.0.4054.90",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59",
  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Vivaldi/4.0",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Vivaldi/4.0",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
  "Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36",
  "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1",
  "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko",
  
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36 Vivaldi/4.0",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36 Vivaldi/4.0"
]

def rand_user_agent
  return USER_AGENTS[rand(USER_AGENTS.length)]
end

class Pr0xy
  attr_accessor :tmp, :proto
  def initialize
    @tmp = []
  end
  def check_if_the_proxy_is_up(host, port)
    proxy = Net::HTTP::Proxy(
      host,
      port
    )
    begin
      Timeout::timeout(10) do
        uri = URI "http://ifconfig.me/"
        req = Net::HTTP::Get::new(uri.path)
        res = proxy.start(uri.host,uri.port) do |http|
          http.request(req)
        end
        if res.code == '200' and
            res.body.length <= 16 and
            res.body.length >= 7 and
            res.body.split(".").length == 4
          print "."
          return true
        end
      end
    rescue => e
    end
    return false
  end
  def get_proxies(file, check)
    if check
      print "\e[33;1mChecking Proxy status\e[0m"
    end
    if File.file? file
      File.open(file, "r").readlines.map do |l|
        sleep 0.02
        Thread.new do
          if l.strip[0] != "#"
            l = l.strip.split(":")
            if check
              if check_if_the_proxy_is_up(l[0],l[1])
                @tmp.append([l[0],l[1]])
              end
            else
              @tmp.append([l[0], l[1]])
            end
          end
        end
        while Thread::list.length > 100;end
      end
    else
      puts "\rUnable to locate proxy file.'#{file}'"
      exit
    end
    while Thread::list.length > 1;end;puts
    if @tmp.length < 1
      print "\rThere is no proxy is alive.\n" +
        "please add proxy in ~/.proxies.txt to take default"+
        " or specify fresh list with -D flag.\n"
      exit
    elsif @tmp.length <= 5
      puts "\r#{@tmp.length} decoys are \e[31mDeductable\e[0m.\nAdd More decoy for better evation."
      sleep 3
    end
    return @tmp
  end
end



# test
#puts  Pr0xy.new.get_proxies("../test/http-proxy.txt")
