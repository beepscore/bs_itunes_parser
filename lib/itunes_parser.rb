require 'rubygems'
require 'library'

class Itunes_parser

  @lib = ItunesParser::Library.new

  # @result is a hash
  @result = @lib.parse(File.read(File.dirname(__FILE__) + './test/test_library.xml'))
  puts @result.inspect
  
  puts @result['first_song'].inspect
  
  puts "library version #{@result['version']}"

  puts "first song's name #{@result['first_song']['name']}"
  puts "first song's artist #{@result['first_song']['artist']}"
  puts "first song's year #{@result['first_song']['year']}"
  puts "first song's kind #{@result['first_song']['kind']}"
  puts "first song's size #{@result['first_song']['size']} bytes"
  
  # note these tags don't have underscore inserted
  puts "first song's sample rate #{@result['first_song']['sample rate']} Hz"
  puts "first song's total time #{@result['first_song']['total time']} millisec"
  
  puts "number of songs #{@result['songs'].count}"
 
end