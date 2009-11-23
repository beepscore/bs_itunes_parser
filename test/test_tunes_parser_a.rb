require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tunes_parser_a'
$LOAD_PATH.unshift(File.dirname(__FILE__))

class TestTunesParserA < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      # itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      itunes_xml_file_name = './test/test_library.xml'
      @my_itunes_parser = ItunesParser::TunesParserA.new(itunes_xml_file_name)   
    end

    should "return a TunesParserA" do
      assert_instance_of(ItunesParser::TunesParserA, @my_itunes_parser)
    end

    # should "probably rename this file and start testing for real" do
    #   flunk "hey buddy, you should probably rename this file and start testing for real"
    # end
  end

end
