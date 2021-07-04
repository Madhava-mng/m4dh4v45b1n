#! /usr/bin/env ruby

require_relative 'version'
require 'resolv'
require 'resolv-replace'



NAME_SERVERS = {
  "Cloudflare": ['1.1.1.1', '1.0.0.1'],
  "Google": ['8.8.8.8', '8.8.4.4'],
  "Quad9": ['9.9.9.9', '149.112.112.112'],
  "OpenDns": ['208.67.222.222', '208.67.220.222']
}

TIME_OUT = 1
MAX_THREAD = 25

def wordlist
  Gem::path.map do |p|
    if File.exist? p+"/gems/m4dh4v45b1n-#{VERSION}/dict/subdomain.txt"
      return p+"/gems/m4dh4v45b1n-#{VERSION}/dict/subdomain.txt"
    end
  end
  puts "enum-subdomain.rb: Unable to deduct default wordlist use -w"
  exit
end
def cache_subdomain
  if !ENV["HOME"].nil?
    if !File.exist? ENV["HOME"]+"/.cache"
      Dir::mkdir ENV["HOME"]+"/.cache"
    end
    if !File.exist? ENV["HOME"]+"/.cache/enum-subdomain"
      Dir::mkdir ENV["HOME"]+"/.cache/enum-subdomain"
    end
    if File.exist? ENV["HOME"]+"/.cache/enum-subdomain"
      return ENV["HOME"]+"/.cache/enum-subdomain"
    end
  end
  return nil
end

CACHE = cache_subdomain
WORDLIST = wordlist

class Subdomain_enum
  attr_accessor :target, :wordlist, :timeout, :max_thread, :out, :verbose,:cache_file,:show_cache, :show_cache_without_d,:show_new
  def initialize
    @timeout = TIME_OUT
    @max_thread = MAX_THREAD
    @wordlist = WORDLIST
    @verbose = false
    @outb=""
    @show_cache = false
    @show_new = true
    @show_cache_without_d = true
  end
  def loader(list)
    return Resolv::DefaultResolver.replace_resolvers([
      Resolv::Hosts.new,
      Resolv::DNS.new(
        nameserver: list,
        ndots: 1
      )
    ])
  end
  def get_domain(domain)
    NAME_SERVERS.keys.shuffle.map do |dns|
      begin
        Timeout::timeout(@timeout) do
          addrs = Resolv::new(
            loader(NAME_SERVERS[dns])
          ).getaddresses(domain)
          if addrs.length > 0
            return addrs
          end
        end  
      rescue Timeout::Error => e
      end
    end
    return []
  end
  def print_domain(domain)
    response = get_domain(domain)
    if response.length > 0
      if !CACHE.nil?
        @cache_file.write("#{domain.gsub(@target, "\x7")}")
      end
      if @verbose
        puts "\e[32m#{domain}\e[0m :#{response.join("\e[2m/\e[0m")}"
      else
        $stdout.print domain + "\n"
      end
      if @out
        @out.write(domain+"\n")
      end
    end
  end
  def check_cache_domain
    if !CACHE.nil?
      if !File.file? CACHE+"/#{@target}.cache"
        File.open(CACHE+"/#{@target}.cache", "a")
      else
        File.open(CACHE+"/#{@target}.cache") do |f|
          data_ = f.read.split("\x7")
          data_ = data_.uniq
          data_.map do |s|
            if @show_new
              if @show_cache
                $stdout.print s+target+"\n"
              else
                puts "\e[32m#{s+@target}\e[0m"
              end
            end
          end
          File.open(CACHE+"/#{@target}.cache", "w") do |f2|
            f2.write(data_.join("\x7"))
          end
          return data_.map {|a| a[0,a.length-1] }
        end
      end
    end
    return []
  end
  def brut
    already_have = check_cache_domain
    if @show_cache
      exit
    end
    if Resolv.getaddresses(@target).length == 0
      print "enum-subdomain.rb: #{@target}:Unreachable.\nDo you wana exit ? "
      tmp = STDIN.gets.chomp
      if ["yes", 'y'].include? tmp
        exit
      end
    end
    if !CACHE.nil?
      @cache_file = File.open(CACHE+"/#{@target}.cache", "a")
    end
    if @out
      @out = File.open(@out, "w")
    end
    wordlist_ = File.open(@wordlist).readlines.uniq
    if @show_cache_without_d
      already_have.map do |a|
        wordlist_.delete(a)
      end
    end
    wordlist_.map do |line|
      Thread::new do
        if !already_have.include? line.chomp
          print_domain(
            [line.chomp, @target.strip].join(".")
          )
        end
      end
      sleep 0.03
      while Thread::list.length > @max_thread;end
    end
    while Thread::list.length > 1;end
    if Thread::list.length == 1
      sleep 0.6
    end
  end
end

