require 'tunes_parser_a'

class ExerciseParser

  itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
  
  my_itunes_parser = ItunesParser::TunesParserA.new(itunes_xml_file_name)

  my_itunes_parser.list_summary
  my_itunes_parser.list_first_song
  my_itunes_parser.list_song(0)
  my_itunes_parser.list_song(1)    
  my_itunes_parser.list_song(2)  
  #my_itunes_parser.populate_metadata

end