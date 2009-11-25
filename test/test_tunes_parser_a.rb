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
    
    should "list a summary" do
      puts "test- list a summary"
      assert_nil(@my_tunes_parser_a.list_summary)
      puts ""
    end
    
    should "return a TunesParserA" do
      puts "test- return a TunesParserA"
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
      puts ""
    end
    
    should "return the number of songs" do
      puts "test- return the number of songs"
      assert_equal(1786, @my_tunes_parser_a.song_count)
      puts ""
    end

  end

end
