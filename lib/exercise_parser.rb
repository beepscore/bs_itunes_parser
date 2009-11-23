require 'itunes_parser'

class Exercise_parser

  my_itunes_parser = Itunes_parser.new

  my_itunes_parser.list_summary
  my_itunes_parser.list_first_song
  my_itunes_parser.populate_metadata

end