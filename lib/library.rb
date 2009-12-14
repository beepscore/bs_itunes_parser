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
      #results hash
      results = {}

      doc     = Nokogiri::XML(xml)

      version = doc.xpath('/plist/dict/string[1]')[0]
      results['version'] = version.content

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
      #  FIXME: use correct path
      all_playlists = doc.xpath('/plist/*/key[. = "Playlists"]')

      # In results hash, set key 'playlists' to empty array.  Ref Thomas pg 46        
      results['playlists'] = []

      all_playlists.each do |track|
        puts "track child = #{track.child}"

        playlist = Playlist.new

        track.xpath('./key').each do |key|
          key_formatted = key.content.downcase.tr(' ', '_')
          playlist.metadata[key_formatted] = key.next.content
        end

        # The results hash 'playlists' key has an array for its value.  Append playlist to the array.
        results['playlists'] << playlist
      end
      
      # ===============================
      # FIXME
      # find all tags with a key of Playlists
      # Search for nodes by xpath
      puts doc.search('/*/*/key[. = "Playlists"]')

      # doc.xpath('/*/*/key[. = "Playlists"]').each do |a_tag|
      #   puts a_tag.content
      # end  
      # ===============================

      results
    end #parse

  end #Library
end #ITunesParser