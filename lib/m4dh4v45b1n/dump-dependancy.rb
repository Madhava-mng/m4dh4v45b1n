CACHE=ENV["HOME"]  + "/.cache"
require 'net/http'

class Dump_data
  attr_accessor :file,:data_
  def initialize()
  end
  def check_proxy_status(proto, host, port)
    proxy = Net::HTTP::Proxy(host, port)
    case proto
    when "http"
      url = "http://ifconfig.me/"
    when "https"
      url = "https://ifconfig.me/"
    else
      url = false
    end
    if url
      begin
        Timeout::timeout(20) do
          uri = URI url
          req = Net::HTTP::Get::new(uri.path)
          res = proxy.start(uri.host,uri.port) do |http|
            http.request(req)
          end
          if res.code == '200' and res.body.length <= 15 and res.body.split(".").length == 4
            puts res.body
            return true
          end
        end
      rescue => e
      end
    end

    return false
  end

  def run_each(name, list_of_ips, type)
    @data_ = []
    list_of_ips.map do |addr|
      addr = addr.split(":")
      sleep 0.02
      Thread.new do
        if check_proxy_status(type, addr[0], addr[1])
          @data_.append(addr[0]+":"+addr[1])
        end
      end
      while Thread::list::length > 1000;end
    end
    while Thread::list.length > 1 ;end
    File.open(CACHE + "/m4dh4v45b1n/#{name}.x7", "a") do |f|
      f.write(@data_.join("\x7"))
    end
  end

  def net_config
    if File.exist? CACHE + "/m4dh4v45b1n/http-proxy.x7"
      File.open(CACHE + "/m4dh4v45b1n/http-proxy.x7","w")
    end
    File.open(CACHE + "/m4dh4v45b1n/proxy.conf", "r").readlines.map do |l|
      if l[0] != "#"
        host, type = l.split(" ")
        puts "\e[32m#{host} \e[0m[#{type}]"
        run_each("#{type}-proxy", Net::HTTP::get_response(URI host).body.split("\n"), type)
      end
    end
    
    
  end
  def cache_check
    if !File.exist? CACHE
      Dir::mkdir(CACHE)
    end
    if !File.exist? CACHE + "/m4dh4v45b1n"
      Dir::mkdir(CACHE + "/m4dh4v45b1n")
      File.open(CACHE + "m4dh4v45b1n/README.txt", "w") do |f|
        f.write("'.' was created by dump-dependance.rb\n")
        f.write("Time: #{Time.now}\n "+'For caches')
      end
    end
    if !File.exist? CACHE + "/m4dh4v45b1n/proxy.conf"
      File.open(CACHE + "/m4dh4v45b1n/proxy.conf", "w") do |f|
        f.write("# proxy_url http/https\n# format host:port\n")
        f.write("https://raw.githubusercontent.com/Madhava-mng/bc/main/proxy/http.txt http\n")
        f.write("https://api.proxyscrape.com/v2/?request=getproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all http\n")
        f.write("https://raw.githubusercontent.com/Madhava-mng/bc/main/proxy/https.txt http\n")
      end
    end
    net_config
  end
end

def main
  Dump_data::new().cache_check
end
main
