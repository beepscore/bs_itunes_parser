# need active_support for underscore method
# Note underscore converts camel case.  It doesn't replace space with underscore.
# http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html
require 'active_support'
require 'nokogiri'
require 'song'
require 'playlist'

module ItunesParser
  # A model class for an iTunes library
  class Library
    
    # The version of the iTunes library e.g. 9.0.2
    attr_accessor :version
    # An array of songs
    attr_accessor :songs
    # A hash of playlists
    attr_accessor :playlists
    
    # Creates an empty library.  To populate the library, call the parse method.
    def initialize
      @version = ''
      @songs = []
      @playlists = {}
    end

    # Parse the xml file argument and populate the library attributes
    # Calls parse_songs and parse_playlists
    def parse(itunes_xml_file_name)

      @doc = Nokogiri::XML(itunes_xml_file_name)
      
      #version_key is a Nokogiri::XML::Element
      version_key = @doc.xpath('/plist/dict/string[1]')[0]
      self.version = version_key.content

      self.parse_songs
      self.parse_playlists            
    end
    
    # Parse and populate the songs
    def parse_songs    
      #  A Nokogiri::XML::NodeSet
       all_songs = @doc.xpath('/plist/dict/dict/dict')

       all_songs.each do |track|

         song = Song.new

         track.xpath('./key').each do |key|
           key_formatted = key.content.downcase.tr(' ', '_')
           song.metadata[key_formatted] = key.next.content
         end
         # Append song to the songs array.
         self.songs << song
       end    
    end
    
    # Parse and populate the playlists
    def parse_playlists
      # ===============================
      # all_playlists.each do |track|
      #   playlist = Playlist.new
      # 
      #   track.xpath('./key').each do |key|
      #     key_formatted = key.content.downcase.tr(' ', '_')
      #     playlist.metadata[key_formatted] = key.next.content
      #   end
      # 
      #   # Append playlist to the playlists array.
      #   results['playlists'] << playlist
      # end
      # ===============================
      
      #  a Nokogiri::XML::NodeSet
      playlist_dicts = @doc.xpath( "/plist/dict/array/dict" )

      playlist_dicts.each do |playlist_xml|
        name = playlist_xml.xpath( "./key[text()='Name']" ).first.next_sibling.content
        puts "Found playlist called '#{name}'"

        if visible = playlist_xml.xpath( "./key[text()='Visible']" )
          unless visible.empty?
            puts "- skipping; invisible"
            next
          end
        end

        if distinguished_kind = playlist_xml.xpath(
          "./key[text()='Distinguished Kind']" )
          unless distinguished_kind.empty?
            puts "- skipping; has a distinguished kind"
            next
          end
        end

        if smart_info = playlist_xml.xpath( "./key[text()='Smart Info']" )
          unless smart_info.empty?
            puts "- skipping; has smart info"
            next
          end
        end

        # we have something we want now
        playlist = Playlist.new
        playlist.metadata['name'] = name
        playlist.metadata['playlist_id'] = playlist_xml.xpath( "./key[text()='Playlist ID']" ).first.next_sibling.content
        tracks = playlist_xml.xpath( "array[1]//integer" )
        puts tracks.map {|t| t.content }

      end

    end # parse_playlists

  end #Library
end #ITunesParser