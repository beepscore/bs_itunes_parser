require 'rubygems'
require 'library'
require 'active_support'
require 'nokogiri'
require 'ostruct'

module ItunesParser

  class TunesParserA

    # A parsed iTunes library model
    attr_accessor :lib

    # Creates a new library, parses the argument, and populates the library
    def initialize(itunes_xml_file_name)   
      @lib = ItunesParser::Library.new    
      @lib.parse(File.read(itunes_xml_file_name))
    end

    # Returns the number of songs in the library
    def song_count
      self.lib.songs.count
    end

    # Returns a string with a simple description of the library
    #   Sample: library_summary returns Summary:  library version = 9.0.2, number of songs = 52
    def library_summary
      "Summary:  library version = #{self.lib.version}, number of songs = #{self.song_count}"
    end    

    # "Puts" the simple description for each song in the library
    def list_songs 
      self.lib.songs.each_value do |song|
        puts song.to_s_simple
      end
    end

    # Returns a hash of songs that match a_key and a_value.
    #   a_key must match exactly.
    #   a_value will match songs that include the string "a_value", and is case insensitive.
    #   Sample: find_songs_for_key_value('artist', 'ryso') finds songs by "Peabo Bryson"
    def find_songs_for_key_value(a_key, a_value)
      songs_for_key_value = {}
      self.lib.songs.each do |track_id, song|
        # skip song if value is nil.  Otherwise string methods downcase and include would fail
        if (song.metadata[a_key] != nil)
          if (song.metadata[a_key].downcase.include?(a_value.downcase))
            songs_for_key_value[track_id] = song
          end
        end
      end
      songs_for_key_value
    end

    # Returns a hash of songs that match song_name.
    #   matches songs that include the song_name string, and is case insensitive.
    def find_songs_for_song_name(song_name)
      find_songs_for_key_value('name', song_name)
    end

    # Returns an array of track_ids for songs that match song_name.
    #   matches songs that include the song_name string, and is case insensitive.
    def find_track_ids_for_song_name(song_name)
      find_songs_for_song_name(song_name).keys
    end


    # Returns a hash of songs that do not contain a_key.
    def find_songs_without_key(a_key)
      songs_without_key =  self.lib.songs.reject do |track_id, song|
        song.metadata.has_key?(a_key)
      end
    end

    # Returns the integer number of unique values in songs for a key such as 'artist', 'album', or 'genre'. 
    #   Sample: count_unique_values_for_key('album') returns 227
    def count_unique_song_values_for_key(a_key)
      values_array = [] #array of values
      self.lib.songs.each_value do |song|
        values_array << song.metadata[a_key]
      end
      unique_count = values_array.uniq.count
      puts "Unique values for key #{a_key} = #{unique_count}"
      unique_count
    end

    # Returns a struct of time components: days, hours, minutes, seconds
    def seconds_to_time_components(secs)     
      # Ref book Fulton The Ruby Way Second Edition pg 227
      # Ref http://nutrun.com/weblog/ruby-struct/
      time_components = OpenStruct.new()      
      time = secs.round                     # Round to nearest second

      time_components.seconds = time % 60   # Get seconds from modulo remainder
      time /= 60                            # Truncate seconds
      time_components.minutes = time % 60   # Extract minutes
      time /= 60                            # Truncate minutes
      time_components.hours = time % 24     # Extract hours
      time /= 24                            # Truncate hours
      time_components.days = time           # Days
      time_components                       # return the struct
    end

    # Returns a struct of time components for the songs in the library.  See seconds_to_time_components
    def songs_time_components
      total_songs_time = 0
      self.lib.songs.each_value do |song|
        total_songs_time += (song.metadata['total_time'].to_f / 1000.0)
      end
      seconds_to_time_components(total_songs_time)     
    end

    # Returns a string of the library playing time.
    #   Sample: library_playing_time returns "Playing time = 10:08:10:50 [dd:hh:mm:ss]"  
    def library_playing_time
      stc = self.songs_time_components
      "Playing time = %02d:%02d:%02d:%02d [dd:hh:mm:ss]" % [stc.days, stc.hours, stc.minutes, stc.seconds]
    end


    # Returns a hash of the songs most recently modified
    def find_recent_songs
      # songs_with_date_modified_pair is a hash
      songs_with_date_modified_pair = self.lib.songs.reject do |track_id, song|
        # reject song if true
        (!song.metadata.has_key?('date_modified')) or (song.metadata['date_modified'] == nil)
      end
      # sort converts hash to an array of nested pairs. a[0] is a key, a[1] is a value
      songs_by_date_modified = songs_with_date_modified_pair.sort do |a, b| 
        b[1].metadata['date_modified'] <=> a[1].metadata['date_modified']
      end
      songs_first_nested_array = songs_by_date_modified.first(3)
      songs_first = {}
      songs_first_nested_array.each do |pair_array|
        songs_first[pair_array[0]] = songs_first[pair_array[1]]
      end
      songs_first
    end

    # Returns a hash of songs with highest play_count
    def find_most_played_songs
      # songs_with_play_count_pair is a hash
      songs_with_play_count_pair = self.lib.songs.reject do |track_id, song|
        # reject song if true
        (!song.metadata.has_key?('play_count')) or (song.metadata['play_count'] == nil)
      end
      # sort converts hash to an array of nested pairs. a[0] is a key, a[1] is a value
      songs_by_play_count = songs_with_play_count_pair.sort do |a, b| 
        b[1].metadata['play_count'].to_i <=> a[1].metadata['play_count'].to_i
      end
      songs_first_nested_array = songs_by_play_count.first(3)
      songs_first = {}
      songs_first_nested_array.each do |pair_array|
        songs_first[pair_array[0]] = songs_first[pair_array[1]]
      end
      songs_first
    end

    # Returns the number of playlists in the library
    def playlists_length
      self.lib.playlists.length
    end

    # "Puts" the simple description for each playlist in the library
    def list_playlists
      # hash .each method requires key-value pair in block, not key only
      self.lib.playlists.each_value do |playlist|
        puts playlist.to_s_simple
      end
    end

    # returns array of playlist_id for a song
    def find_playlists_for_song(song_name)
      track_array = self.find_track_ids_for_song_name(song_name)
      # this array contains matching playlists id for track_ids
      matching_playlists_array = []
      # enumerate through each track id for the song name   
      track_array.each do |a_track_id|

        # enumerate through playlists
        self.lib.playlists.each_value do |playlist|
          if playlist.track_ids.include?(a_track_id)
            matching_playlists_array << playlist.metadata['playlist_id']
          end
        end         
      end        
      puts matching_playlists_array
      matching_playlists_array
    end

  end
end
