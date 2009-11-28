require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tunes_parser_a'
$LOAD_PATH.unshift(File.dirname(__FILE__))

# *** Note:  tests run in alphabetical order, not in order of appearance! ***
class TestTunesParserA < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      puts "setup fileRead Context"
      # itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      itunes_xml_file_name = './test/test_library.xml'
      @my_tunes_parser_a = ItunesParser::TunesParserA.new(itunes_xml_file_name)
    end
    
    should "01 return a TunesParserA" do
      puts "test- return a TunesParserA"
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
      puts ""
    end
    
    should "02 list a summary" do
      puts "test- list a summary"
      assert_nil(@my_tunes_parser_a.list_summary)
      puts ""
    end
    
    should "03 return the number of songs" do
      puts "test- return the number of songs"
      assert_equal(1786, @my_tunes_parser_a.song_count)
      puts ""
    end
    
    should "04 list first song" do
       puts "test- list first song"
       # first song in the songs array
       first_song_in_songs = @my_tunes_parser_a.parsed_lib['songs'][0]
       puts "first song = #{first_song_in_songs.inspect}"       
       assert_not_nil(first_song_in_songs)
       puts ""
       
       # first_song in hash, also used in list_first_song method
       @my_tunes_parser_a.list_first_song
       assert_not_nil(@my_tunes_parser_a.parsed_lib['first_song'])      
       puts ""
     end
    
    should "05 last song not nil, song after last is nil" do
      puts "test- last song not nil, song after last is nil"
      index_of_last_song = @my_tunes_parser_a.song_count - 1
      
      puts ""
      last_song = @my_tunes_parser_a.parsed_lib['songs'][index_of_last_song]
      puts "last song = #{last_song.inspect}"
      assert_not_nil(last_song)
      puts ""
      
      after_last_song = @my_tunes_parser_a.parsed_lib['songs'][index_of_last_song +1]
      puts "after last song = #{after_last_song.inspect}"
      assert_nil(after_last_song)
      puts ""
    end
    
    should "06 list songs" do
       puts "test- list songs"
       @my_tunes_parser_a.list_songs
       assert_not_nil(true)
       puts ""
     end    

  end

end
