require 'rubygems'
require 'library'

class Itunes_parser

  def initialize(itunes_xml_file_name)
    
    @lib = ItunesParser::Library.new    
    # @parsed_lib is a hash
    # @parsed_lib = @lib.parse(File.read(File.dirname(__FILE__) + './test/test_library.xml'))
    @parsed_lib = @lib.parse(File.read(itunes_xml_file_name))
    #puts @parsed_lib.inspect
    
  end

  def list_summary  
    puts "library version #{@parsed_lib['version']}"
    puts "number of songs #{@parsed_lib['songs'].count}"
  end

  def list_first_song
    puts @parsed_lib['first_song'].inspect
    puts "first song's name #{@parsed_lib['first_song']['name']}"
    puts "first song's artist #{@parsed_lib['first_song']['artist']}"
    puts "first song's year #{@parsed_lib['first_song']['year']}"
    puts "first song's kind #{@parsed_lib['first_song']['kind']}"
    puts "first song's size #{@parsed_lib['first_song']['size']} bytes"

    # note these tags don't have underscore inserted
    puts "first song's sample rate #{@parsed_lib['first_song']['sample rate']} Hz"
    puts "first song's total time #{@parsed_lib['first_song']['total time']} millisec"
  end

  def populate_metadata 
    @parsed_lib['songs'].each do |song|
      puts song

      # song('/key').each do |key|
      #   song.metadata[key.content.downcase.underscore] = key.next.content
      # end

    end 

  end

end