module ItunesParser
  class Song
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
    
    def to_s_simple
        "track_id = #{@metadata['track_id']}  name = #{@metadata['name']}"
    end
    
  end
end