require 'helper'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'tunes_parser_a'
$LOAD_PATH.unshift(File.dirname(__FILE__))

# *** Note:  tests run in alphabetical order, not in order of appearance! ***
class TestTunesParserA < Test::Unit::TestCase

  context "#fileRead" do    
    setup do
      puts "setup fileRead Context"
      # @itunes_xml_file_name = File.dirname(__FILE__) + './test/test_library.xml'
      # @itunes_xml_file_name = 'test/test_library.xml'
      @itunes_xml_file_name = 'test/testing.xml'
      @my_tunes_parser_a = ItunesParser::TunesParserA.new(@itunes_xml_file_name)
    end

    should "01 return a TunesParserA" do
      puts "test- return a TunesParserA"
      assert_instance_of(ItunesParser::TunesParserA, @my_tunes_parser_a)
    end

    should "02 return a string library summary" do
      puts "test- return a string library summary"
      puts @my_tunes_parser_a.library_summary
      assert_instance_of(String, @my_tunes_parser_a.library_summary)
    end

    should "03 return the number of songs" do
      puts "test- return the number of songs"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(1786, @my_tunes_parser_a.songs_count)
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(52, @my_tunes_parser_a.songs_count)
      end
    end

    should "04 provide correct metadata values" do
      puts "test- provide correct metadata values"
      puts "" 
      if @itunes_xml_file_name == 'test/test_library.xml'
        a_song = @my_tunes_parser_a.lib.songs['1018']
        assert_instance_of(ItunesParser::Song, a_song)
        assert_equal("Dan Sartain", a_song.metadata['artist'])
        assert_equal("Totem Pole", a_song.metadata['name'])
        assert_equal("2006", a_song.metadata['year'])
        assert_equal("MPEG audio file", a_song.metadata['kind'])
        # size in bytes
        assert_equal("5191680", a_song.metadata['size'])
        # sample rate in Hz
        assert_equal("44100", a_song.metadata['sample_rate'])
        # total time in msec
        assert_equal("180035", a_song.metadata['total_time'])
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        a_song = @my_tunes_parser_a.lib.songs['66']
        assert_instance_of(ItunesParser::Song, a_song)
        assert_equal("Bruce Adler", a_song.metadata['artist'])
        assert_equal("Arabian Nights", a_song.metadata['name'])
        assert_equal("1992", a_song.metadata['year'])
        assert_equal("MPEG audio file", a_song.metadata['kind'])
        # size in bytes
        assert_equal("1898624", a_song.metadata['size'])
        # sample rate in Hz
        assert_equal("44100", a_song.metadata['sample_rate'])
        # total time in msec
        assert_equal("79725", a_song.metadata['total_time'])
      end

    end

    # should "05 list songs" do
    #   puts "test- list songs"
    #   @my_tunes_parser_a.list_songs
    #   assert_not_nil(true)
    #   puts ""
    # end 

    should "06 return a string describing song" do
      puts "test- return a string describing song"
      if @itunes_xml_file_name == 'test/test_library.xml'
        a_song = @my_tunes_parser_a.lib.songs['1018']
     end
      if @itunes_xml_file_name == 'test/testing.xml'
        a_song = @my_tunes_parser_a.lib.songs['66']
     end
      puts a_song.to_s_simple
      assert_instance_of(String, a_song.to_s_simple)
    end

    should "07 find songs for key value" do
      puts "test- find songs for key value"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(9, @my_tunes_parser_a.find_songs_for_key_value('artist', 'Cause4Concern').count)
        assert_equal(4, @my_tunes_parser_a.find_songs_for_key_value('artist', "SILENT WITNESS \& BREAK").count)
        assert_equal(8, @my_tunes_parser_a.find_songs_for_key_value('artist', "SILENT").count)
        assert_equal(8, @my_tunes_parser_a.find_songs_for_key_value('artist', "Silent").count)
        assert_equal(8, @my_tunes_parser_a.find_songs_for_key_value('artist', "ilen").count)
        assert_equal(41, @my_tunes_parser_a.find_songs_for_key_value('year', '2001').count)
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "Peabo Bryson Regina Belle, & David Friedman").count)
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "Peabo Bryson Regina Belle, \& David Friedman").count)
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "Peabo").count)
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "peabo").count)
        assert_equal(14, @my_tunes_parser_a.find_songs_for_key_value('artist', "ryso").count)
        assert_equal(21, @my_tunes_parser_a.find_songs_for_key_value('year', '1992').count)
        assert_equal(21, @my_tunes_parser_a.find_songs_for_key_value('year', '92').count)
      end
    end

    should "08 count unique song values for key" do
      puts "test- count unique song values for key"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(1786, @my_tunes_parser_a.count_unique_song_values_for_key('track_id'))
        assert_equal(237, @my_tunes_parser_a.count_unique_song_values_for_key('artist'))
        assert_equal(227, @my_tunes_parser_a.count_unique_song_values_for_key('album'))
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(52, @my_tunes_parser_a.count_unique_song_values_for_key('track_id'))
        assert_equal(7, @my_tunes_parser_a.count_unique_song_values_for_key('artist'))
        assert_equal(2, @my_tunes_parser_a.count_unique_song_values_for_key('album'))
      end
    end

    should "09a convert seconds to time components" do
      puts "test- convert seconds to time components"
      assert_equal(0, @my_tunes_parser_a.seconds_to_time_components(0).seconds)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(24*60*60).days)
      test_secs = 3662
      assert_equal(2, @my_tunes_parser_a.seconds_to_time_components(test_secs).seconds)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(test_secs).minutes)
      assert_equal(1, @my_tunes_parser_a.seconds_to_time_components(test_secs).hours)
      assert_equal(0, @my_tunes_parser_a.seconds_to_time_components(test_secs).days)      
    end

    should "09b return library songs time components" do
      puts "test- library songs time components"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(10, @my_tunes_parser_a.songs_time_components.days)
        assert_equal(8, @my_tunes_parser_a.songs_time_components.hours)
        assert_equal(10, @my_tunes_parser_a.songs_time_components.minutes)
        assert_equal(50, @my_tunes_parser_a.songs_time_components.seconds) 
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(0, @my_tunes_parser_a.songs_time_components.days)
        assert_equal(1, @my_tunes_parser_a.songs_time_components.hours)
        assert_equal(48, @my_tunes_parser_a.songs_time_components.minutes)
        assert_equal(13, @my_tunes_parser_a.songs_time_components.seconds) 
      end
    end

    should "09c return library playing time" do
      puts "test- library playing time"
      puts @my_tunes_parser_a.library_playing_time
      #  TODO: this answer seems about double expected.
      #  are we double counting due to albums?  Duplicate songs with different sample rates?
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal("Playing time = 10:08:10:50 [dd:hh:mm:ss]", @my_tunes_parser_a.library_playing_time)
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal("Playing time = 00:01:48:13 [dd:hh:mm:ss]", @my_tunes_parser_a.library_playing_time)
      end
    end


    should "10 find songs without key" do
      puts "test- find songs without key"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(302, @my_tunes_parser_a.find_songs_without_key('album').count)
        assert_equal(542, @my_tunes_parser_a.find_songs_without_key('genre').count)
        assert_equal(@my_tunes_parser_a.songs_count, @my_tunes_parser_a.find_songs_without_key('key_without_match').count)
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(0, @my_tunes_parser_a.find_songs_without_key('album').count)
        assert_equal(31, @my_tunes_parser_a.find_songs_without_key('comments').count)
        assert_equal(@my_tunes_parser_a.songs_count, @my_tunes_parser_a.find_songs_without_key('key_without_match').count)
      end
    end

    should "11 return the number of playlists" do
      puts "test- return the number of playlists"
      @my_tunes_parser_a.list_playlists
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_equal(36, @my_tunes_parser_a.playlists_length)
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_equal(2, @my_tunes_parser_a.playlists_length)
      end
    end

    should "12 return a playlist" do
      puts "test- return a playlist"
      if @itunes_xml_file_name == 'test/test_library.xml' 
        assert_instance_of(ItunesParser::Playlist, @my_tunes_parser_a.lib.playlists['9416'])
      end
      if @itunes_xml_file_name == 'test/testing.xml' 
        assert_instance_of(ItunesParser::Playlist, @my_tunes_parser_a.lib.playlists['697'])
      end
    end

    should "13 return correct playlist track id" do
      puts "test- return correct playlist track id"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal('1040', @my_tunes_parser_a.lib.playlists['9283'].track_ids[1])
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal('66', @my_tunes_parser_a.lib.playlists['697'].track_ids[4])  
      end
    end

    should "14 find songs for song name" do
      puts "test- find songs for song name"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(['1040'], @my_tunes_parser_a.find_songs_for_song_name('built_for_war_3-19_master').keys)
        assert_equal(['1500'], @my_tunes_parser_a.find_songs_for_song_name('rinz').keys)
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(['66'], @my_tunes_parser_a.find_songs_for_song_name('Arabian Nights').keys)
        assert_equal(['66'], @my_tunes_parser_a.find_songs_for_song_name('rabia').keys)
        assert_equal(['80', '86'], @my_tunes_parser_a.find_songs_for_song_name('Prince Ali').keys)
      end
    end

    should "15 find track ids for song name" do
      puts "test- find_track_ids_for_song_name"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(['1040'], @my_tunes_parser_a.find_track_ids_for_song_name('built_for_war_3-19_master'))
        assert_equal(['1500'], @my_tunes_parser_a.find_track_ids_for_song_name('Shrinz (Quadrant Remix) - FINAL'))
      end

      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(['66'], @my_tunes_parser_a.find_track_ids_for_song_name('Arabian Nights'))
        assert_equal(['80', '86'], @my_tunes_parser_a.find_track_ids_for_song_name('Prince Ali'))
      end
    end

    should "18 find playlists for song" do
      puts "test- find playlists for song"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(["8975", "9283", "9571", "9091", "10011"], @my_tunes_parser_a.find_playlists_for_song('built_for_war_3-19_master'))
        assert_equal(['9571', '10011'], @my_tunes_parser_a.find_playlists_for_song('Shrinz (Quadrant Remix) - FINAL'))
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(['697', '664'], @my_tunes_parser_a.find_playlists_for_song('Arabian Nights'))
        assert_equal(['697'], @my_tunes_parser_a.find_playlists_for_song("Aladdin's Word"))
      end
    end


    should "19 find songs by value for key" do
      puts "test- find songs by value for key"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(["1056", "1058", "4120"], @my_tunes_parser_a.find_songs_by_value_for_key('total_time', true, true).keys)
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(["246", "98", "236"], @my_tunes_parser_a.find_songs_by_value_for_key('total_time', true, false).keys)
      end
    end


    should "20 find recent songs" do
      puts "test- find recent songs"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(["4850", "4852", "1896"], @my_tunes_parser_a.find_recent_songs.keys)
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(["262", "264", "268"], @my_tunes_parser_a.find_recent_songs.keys)
      end
    end

    should "21 find most played songs" do
      puts "test- find most played songs"
      if @itunes_xml_file_name == 'test/test_library.xml'
        assert_equal(["3150", "3140", "3142"], @my_tunes_parser_a.find_most_played_songs.keys)
      end
      if @itunes_xml_file_name == 'test/testing.xml'
        assert_equal(["66", "70", "268"], @my_tunes_parser_a.find_most_played_songs.keys)
      end
    end


  end
end
