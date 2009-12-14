# need active_support for underscore method
# Note underscore converts camel case.  It doesn't replace space with underscore.
# http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/String/Inflections.html
require 'active_support'
require 'nokogiri'
require 'song'
require 'playlist'

module ItunesParser
  class Library

    attr_accessor :songs
    attr_accessor :playlists

    def initialize
      # instance variable @songs array
      @songs = []
      @playlists = []
    end
    
    def parse(xml)
      # results hash
      results = {}

      doc     = Nokogiri::XML(xml)

      version = doc.xpath('/plist/dict/string[1]')[0]
      results['version'] = version.content

      #  all_songs is a Nokogiri::XML::NodeSet
      all_songs = doc.xpath('/plist/dict/dict/dict')

      # In results hash, set key 'songs' to empty array.  Ref Thomas pg 46        
      results['songs'] = []

      all_songs.each do |track|

        song = Song.new

        track.xpath('./key').each do |key|
          key_formatted = key.content.downcase.tr(' ', '_')
          song.metadata[key_formatted] = key.next.content
        end

        # The results hash 'songs' key has an array for its value.  Append song to the array.
        results['songs'] << song
      end

      # ===============================
      # In results hash, set key 'playlists' to empty array.  Ref Thomas pg 46        
      # results['playlists'] = []
      # 
      # all_playlists.each do |track|
      #   playlist = Playlist.new
      # 
      #   track.xpath('./key').each do |key|
      #     key_formatted = key.content.downcase.tr(' ', '_')
      #     playlist.metadata[key_formatted] = key.next.content
      #   end
      # 
      #   # The results hash 'playlists' key has an array for its value.  Append playlist to the array.
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
      # ===============================

      results
    end #parse

  end #Library
end #ITunesParser