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
      @song_count = self.parsed_lib['songs'].count
    end

    def list_summary
      puts "library version #{self.parsed_lib['version']}"
      puts "number of songs #{self.song_count}"
    end    

    def list_first_song
      puts self.parsed_lib['first_song'].inspect
      puts "first song's class #{self.parsed_lib['first_song'].class}"
      puts "first song's name #{self.parsed_lib['first_song']['name']}"
      puts "first song's artist #{self.parsed_lib['first_song']['artist']}"
      puts "first song's year #{self.parsed_lib['first_song']['year']}"
      puts "first song's kind #{self.parsed_lib['first_song']['kind']}"
      puts "first song's size #{self.parsed_lib['first_song']['size']} bytes"
      # Note: these tags don't have underscore inserted
      puts "first song's sample rate #{self.parsed_lib['first_song']['sample rate']} Hz"
      puts "first song's total time #{self.parsed_lib['first_song']['total time']} millisec"
    end

    def list_songs 
      self.parsed_lib['songs'].each do |song|
        puts song.to_s_simple
      end
    end
 
    def find_songs_for_artist
      songs_for_artist = self.parsed_lib['songs'].find_all do |song|
        song.metadata['artist']=='Cause4Concern'
      end
      songs_for_artist
    end
    
    def find_songs_for_key_value(a_key, a_value)
      songs_for_key_value = self.parsed_lib['songs'].find_all do |song|
        song.metadata[a_key]== a_value
      end
      songs_for_key_value
    end

    def count_unique_values_for_key(a_key)
      values_array = [] #array of values
      self.parsed_lib['songs'].each do |song|
        values_array << song.metadata[a_key]
      end
      puts values_array.uniq.count
      values_array.uniq.count
    end
   
  end

end
