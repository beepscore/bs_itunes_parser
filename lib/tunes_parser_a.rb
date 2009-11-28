require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'

module ItunesParser

  class TunesParserA

    # parsed_lib is a hash
    attr_accessor :parsed_lib

    def initialize(itunes_xml_file_name)   
      @lib = ItunesParser::Library.new    
      @parsed_lib = @lib.parse(File.read(itunes_xml_file_name))
    end

    def song_count
      @song_count = parsed_lib['songs'].count
    end

    def list_summary
      puts "library version #{parsed_lib['version']}"
      puts "number of songs #{self.song_count}"
    end    

    def list_first_song
      puts parsed_lib['first_song'].inspect
      puts "first song object #{parsed_lib['first_song']}"
      puts "first song's name #{parsed_lib['first_song']['name']}"
      puts "first song's artist #{parsed_lib['first_song']['artist']}"
      puts "first song's year #{parsed_lib['first_song']['year']}"
      puts "first song's kind #{parsed_lib['first_song']['kind']}"
      puts "first song's size #{parsed_lib['first_song']['size']} bytes"

      # Note: these tags don't have underscore inserted
      puts "first song's sample rate #{parsed_lib['first_song']['sample rate']} Hz"
      puts "first song's total time #{parsed_lib['first_song']['total time']} millisec"
    end

    def list_song(song_index)
      puts "songs[#{song_index}] = #{parsed_lib['songs'][song_index].inspect}"
    end

    def list_songs 
      parsed_lib['songs'].each do |song|
        puts "track id = #{song.metadata['track id']}  name = #{song.metadata['name']}"
      end
    end

  end

end
