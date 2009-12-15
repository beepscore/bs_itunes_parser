# need active_support for underscore method
# Note underscore converts camel case.  It doesn't replace space with underscore.
# http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html
require 'active_support'
require 'nokogiri'
require 'song'
require 'playlist'

module ItunesParser
  class Library

    attr_accessor :version
    attr_accessor :songs
    attr_accessor :playlists

    def initialize
      @version = ''
      @songs = []
      @playlists = []
    end

    # parse the xml file and populate the library attributes
    def parse(itunes_xml_file_name)

      doc = Nokogiri::XML(itunes_xml_file_name)
      
      #version_key is a Nokogiri::XML::Element
      version_key = doc.xpath('/plist/dict/string[1]')[0]
      self.version = version_key.content

      #  all_songs is a Nokogiri::XML::NodeSet
      all_songs = doc.xpath('/plist/dict/dict/dict')

      all_songs.each do |track|

        song = Song.new

        track.xpath('./key').each do |key|
          key_formatted = key.content.downcase.tr(' ', '_')
          song.metadata[key_formatted] = key.next.content
        end
        # Append song to the songs array.
        self.songs << song
      end
    end #parse


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
      
      #  playlist_dicts is a Nokogiri::XML::NodeSet
      playlist_dicts = doc.xpath( "/plist/dict/array/dict" )

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
        tracks = playlist_xml.xpath( "array[1]//integer" )
        puts tracks.map {|t| t.content }

      end

    end # parse_playlists

  end #Library
end #ITunesParser