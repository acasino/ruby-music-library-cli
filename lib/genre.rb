class Genre

    extend Concerns::Findable

    attr_accessor :name

    @@all = [] #class variable to store all saved instances of the class

    def initialize(name) #can accept name upon init and set property correctly
        @name = name 
        @songs = [] #creates 'songs' property set to empty array (genre has many songs)
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
        new_genre = Genre.new(name)
        new_genre.save
        new_genre
    end

    def songs #return 'songs' collection (genre has many songs)
        @songs
    end

    def artists #return collection of artists for all genre's songs (genre has many artists through songs)
        songs.collect {|song| song.artist}.uniq
    end

end

