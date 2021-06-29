require 'net/http'
require_relative 'rand-util'

class Wordpress_user_enum
  attr_accessor :url
  def initialize(url)
    @url = url
    @tmp_list = []
  end
  def search_for_mails
    res = Net::HTTP::get_response(URI(@url), {"User-Agent":rand_user_agent})
    URI.extract(res.body) do |url|
      if url.include? "mail.com"
        puts "Mail: #{url}"
      end
    end
  end
  def enum
    Thread::new{search_for_mails}
    result = ''
    begin
      for id in 0..30
        req = Net::HTTP::get_response(URI @url+'?author='+id.to_s)
        if req.code == '200'
          req.body.split("\n") do |l|
            if l.include? '/author/'
              l.split("http").each do |ll|
                if ll.include? '/author/'
                  ll.length.times do |i|
                    if ll[i,8] == '/author/'
                      @tmp_list.append(ll[i+8,100].split("/")[0])
                    end
                  end
                end
              end
            end
          end
        elsif req.code == '404'
          break
        end
      end
      @tmp_list = @tmp_list.uniq
      @tmp_list.each do |i|
        result += "\e[32mUSER_FOUND\e[0m: #{i}\n"
      end
      if result
        print result
        return
      end
    rescue => e
      puts e
    end
    print 'No result found'
  end
end
