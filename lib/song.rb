module ItunesParser
  class Song
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
    
    def list_song_simple
        puts "track id = #{@metadata['track id']}  name = #{@metadata['name']}"
    end
    
  end
end