require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'playlist'
$LOAD_PATH.unshift(File.dirname(__FILE__))

# *** Note:  tests run in alphabetical order, not in order of appearance! ***
class TestPlaylist < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      puts "setup fileRead Context"
      # @itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      #@itunes_xml_file_name = 'test/test_library.xml'
      @itunes_xml_file_name = 'test/testing.xml'
      @my_tunes_parser_a = ItunesParser::TunesParserA.new(@itunes_xml_file_name)
    end

    should "01 return a TunesParserA" do
      puts "test- return a TunesParserA"
      puts ""
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
    end


  end
end
