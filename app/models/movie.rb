class Movie < ActiveRecord::Base
    def self.ratings
      rs = []
      @relation.each { |movie|
        if rs.exclude? movie.rating
          rs.append(movie.rating)
        end 
      }
      return rs.sort
    end
end
