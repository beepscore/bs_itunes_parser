module ItunesParser
  class Playlist
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
    
    def to_s_simple
        "playlist id = #{@metadata['playlist id']}  name = #{@metadata['name']}"
    end
    
  end
end