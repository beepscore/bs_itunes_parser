require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'

module ItunesParser

  class TunesParserA

    def initialize(itunes_xml_file_name)   
      @lib = ItunesParser::Library.new    
      # @parsed_lib is a hash
      @parsed_lib = @lib.parse(File.read(itunes_xml_file_name))
      #puts @parsed_lib.inspect
    end

    def song_count
      @song_count = @parsed_lib['songs'].count
    end

    def list_summary
      puts "library version #{@parsed_lib['version']}"
      puts "number of songs #{self.song_count}"
    end    

    def list_first_song
      puts @parsed_lib['first_song'].inspect
      puts "first song object #{@parsed_lib['first_song']}"
      puts "first song's name #{@parsed_lib['first_song']['name']}"
      puts "first song's artist #{@parsed_lib['first_song']['artist']}"
      puts "first song's year #{@parsed_lib['first_song']['year']}"
      puts "first song's kind #{@parsed_lib['first_song']['kind']}"
      puts "first song's size #{@parsed_lib['first_song']['size']} bytes"

      # note these tags don't have underscore inserted
      puts "first song's sample rate #{@parsed_lib['first_song']['sample rate']} Hz"
      puts "first song's total time #{@parsed_lib['first_song']['total time']} millisec"
    end

    def list_song(song_index)
      puts "songs[#{song_index}] = #{@parsed_lib['songs'][song_index].inspect}"
    end

    def list_songs 
      @parsed_lib['songs'].each do |song|
        puts song
        # song('/key').each do |key|
        #   song.metadata[key.content.downcase.underscore] = key.next.content
        # end 
      end
    end

    def populate_metadata 
      puts @parsed_lib['songs'][0]
      # @parsed_lib['songs'][0]('/key').each do |key|
      #    metadata[key.content.downcase.underscore] = key.next.content
      #  end

      # add key-value pair to results hash.  Ref Thomas pg 46
      current_song = @parsed_lib['songs'][0]
      # inject method Ref Thomas pg 52-53
      current_song.inject({}) do |song_info, key|
        # add key-value pair to song_info hash.
        song_info[key.content.downcase.underscore] = key.next.content
        song_info
      end

    end

  end

end
