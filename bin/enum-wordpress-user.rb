#! /bin/env ruby
require 'm4dh4v45b1n'
if !ARGV[-1].nil?
  Wordpress_user_enum::new(ARGV[-1]).enum
else
  puts "enum-wordpress-user.rb <url>"
end
