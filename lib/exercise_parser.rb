require 'itunes_parser'

class Exercise_parser

  itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
  
  my_itunes_parser = ItunesParser::Itunes_parser.new(itunes_xml_file_name)

  my_itunes_parser.list_summary
  my_itunes_parser.list_first_song
  my_itunes_parser.populate_metadata

end