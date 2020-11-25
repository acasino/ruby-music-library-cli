class MusicLibraryController

    attr_reader :path

    def initialize(path = "./db/mp3s") #upon init accepts optional path w/default. Instantiates MusicImporter object which it will use to import songs from specified library
        @path = path
        MusicImporter.new(path).import  #invokes import method on the created MusicImporter object
    end

    def call #starts CLI and prompts user for input. Welcome the user
        
        input = "" #input starts as empty string, they'll gets.strip after menu
        
        while input != "exit"  #continue to puts directions unless user hits exit
            puts "Welcome to your music library!"  
            puts "To list all of your songs, enter 'list songs'."
            puts "To list all of the artists in your library, enter 'list artists'."
            puts "To list all of the genres in your library, enter 'list genres'."
            puts "To list all of the songs by a particular artist, enter 'list artist'."
            puts "To list all of the songs of a particular genre, enter 'list genre'."
            puts "To play a song, enter 'play song'."
            puts "To quit, type 'exit'."
            puts "What would you like to do?"

            input = gets.strip #gets user input

            case input  #CLI commands; Do method in case of user input:
            when "list songs"
                list_songs
            when "list artists"
                list_artists
            when "list genres"
                list_genres
            when "list artist"
                list_songs_by_artist
            when "list genre"
                list_songs_by_genre
            when "play song"
                play_song
            end
        end
    end

    def list_songs #prints all songs in the music library in a numbered list (alphabetized by song name). Is not hard coded
        Song.all.sort{ |a, b| a.name <=> b.name}.each.with_index(1) do |s, i| #use spaceship operator to compare, start from index of 1
            puts "#{i}. #{s.artist.name} - #{s.name} - #{s.genre.name}" #puts out index, artist, song name, genre name through interpolation
        end
    end

    def list_artists #prints all artists in music library in a numbered list (alphabetized by artist name)
        Artist.all.sort{ |a, b| a.name <=> b.name }.each.with_index(1) do |a, i| #sort all artists alpha using spaceship operator, and for each of those start index at 1
            puts "#{i}. #{a.name}" #interpolate results
        end
    end

    def list_genres  ##same as above
        Genre.all.sort{ |a, b| a.name <=> b.name }.each.with_index(1) do |g, i|
            puts "#{i}. #{g.name}"
        end
    end

    def list_songs_by_artist #accepts user input, prints all songs of partic artist in a numbered list (alphabetized by song name)
        puts "Please enter the name of an artist:" 
        input = gets.strip

        if artist = Artist.find_by_name(input)  #use Artist.find_by_name class method with input as argument
            artist.songs.sort{ |a, b| a.name <=> b.name }.each.with_index(1) do |s, i|
                puts "#{i}. #{s.name} - #{s.genre.name}"
            end
        end
    end

    def list_songs_by_genre #accepts user input, prints all songs of particular artist based on genre
        puts "Please enter the name of a genre:"
        input = gets.strip

        if genre = Genre.find_by_name(input)
            genre.songs.sort{ |a, b| a.name <=> b.name }.each.with_index(1) do |s, i|
                puts "#{i}. #{s.artist.name} - #{s.name}"
            end
        end
    end

    def play_song #prompts user to choose song from alphabetized list output by #list_songs
        puts "Which song number would you like to play?" #ask user for input
        input = gets.strip.to_i

        if (1..Song.all.length).include?(input) #check if the input number is included within full length of songs
            song = Song.all.sort{ |a, b| a.name <=> b.name }[input - 1] #song is all songs sorted alphabetically, minus 1 (since starts at 0)
        end

        puts "Playing #{song.name} by #{song.artist.name}" if song #only puts out result if matching song is found (ie: song = true)
    end

end
