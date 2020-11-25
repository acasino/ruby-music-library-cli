class Artist

    extend Concerns::Findable

    attr_accessor :name
    attr_reader :songs

    @@all = [] #class variable to store all saved instances of the class

    def initialize(name) #can accept name upon init and set property correctly
        @name = name 
        @songs = [] #creates 'songs' instance variable set to an empty array (artist has many songs)
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
        new_artist = Artist.new(name)
        new_artist.save
        new_artist
    end

    def songs #returns the artists songs collection (artist has many songs)
        @songs
    end

    def add_song(song)
        song.artist ||= self  #if left side false or nil, set equal to self (or equals operator)
        if @songs.include?(song) == false
            @songs << song
        end
    end

    def genres #returns collection of genres for all artist's songs (artist has many genres through songs)
        songs.collect {|song| song.genre}.uniq #get all unique instances
    end

end