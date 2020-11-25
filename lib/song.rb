require 'pry'

class Song

    attr_accessor :name, :artist, :genre

    @@all = [] #class variable to store all saved instances of the class

    def initialize(name, artist = nil, genre = nil) #can accept name upon init and set property correctly, optional artist second argument
        @name = name
        # @artist = artist #set artist object to be assigned to song's artist property (song belongs to artist)
        self.artist= artist if artist #invokes #artist= instead of assigning @artist instance variable to ensure assoc upon init
        self.genre= genre if genre #assigns genre to a song (song belongs to genre)
        #save  #call save method to add instance to @@all
    end

    def self.all 
        @@all  #class method to call all saved instances 
    end

    def save
        @@all << self  #method to save instance to class variable
    end

    def self.destroy_all #class method to clear all contents of class variable
        @@all.clear
    end

    def self.create(name)
        new_song = new(name)
        new_song.save
        new_song
    end

    def artist=(artist)  #invokes Artist method #add_song to add itself to artist's collection of songs
        @artist = artist    ##(artist has many songs) 
        artist.add_song(self)   ##note this violates single source of truth
    end

    def genre=(genre) 
        @genre = genre #assign genre to song (song belongs to genre) 
        genre.songs << self unless genre.songs.include?(self) #adds song to collection of songs (genre has many songs)
    end

    def self.find_by_name(name)  #find a song instance in @@all by the name property of the song
        all.detect {|s| s.name == name}
    end

    def self.find_or_create_by_name(name) #returns an existing song with the provided name if one exists in @@all
        find_by_name(name) || create(name)
    end

    def self.new_from_filename(filename) #initializies a song based on passed in filename, invokes appropriate Findable methods to avoid duplicating objs
        parts = filename.split(" - ") #split filename into different parts
        artist_name, song_name, genre_name = parts[0], parts[1], parts[2].gsub(".mp3", "") #equate parts to array index values, remove mp3

        artist = Artist.find_or_create_by_name(artist_name) #set artist and genre properties using inputs from above
        genre = Genre.find_or_create_by_name(genre_name)

        new(song_name, artist, genre) #initialize new song using the above values by calling new
    end

    def self.create_from_filename(filename) #initialize and saves a song based on the passed in filename
        new_from_filename(filename).tap{|s| s.save} #invokes .new_from_filename instead of recoding same functionality
                                    ##tap allows you to manipulate object and return to it after the block
    end



end

