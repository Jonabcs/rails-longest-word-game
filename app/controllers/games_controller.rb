require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [*1..10]
    @letters = @letters.map do
      Array('A'..'Z').sample
    end

  end

  def score
    @answer = params["quess"].upcase.split("")
    @text = "The word is included"
    if check_array(params[:random_array].split(" "), @answer) == false
      @text = "Sorry but #{params["quess"].upcase} cant be build out of #{params[:random_array]}."
    elsif check_dict(@answer.join('')) == false
      @text = "Sorry but #{params["quess"].upcase} is not an english word."
    else
      @text = "CONGRATULATIONS! #{params["quess"].upcase} is a valid english word."
    end    
  end

    def check_array(grid_array, user_array)
      value = true
      user_array.each do |l|
        if grid_array.include? l
          grid_array.delete_at(grid_array.index(l))
        else
          value = false
        end
      end
      return value
    end

    def check_dict(attempt)
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      # url = URI.encode(url)
      attempt_verf = URI.open(url).read
      if JSON.parse(attempt_verf)["found"]
        return true
      else
        return false
      end
    end

    def run_game(attempt, grid, start_time, end_time)
      # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
      time_cal = end_time - start_time
      score_cal = attempt.size.to_f / time_cal
      return { time: time_cal, score: 0, message: "not in the grid" } unless check_array(grid, attempt.upcase.chars)
    
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      attempt_verf = URI.open(url).read
      if JSON.parse(attempt_verf)["found"]
        return { time: time_cal, score: score_cal, message: "well done" }
      else
        return { time: time_cal, score: 0, message: "not an english word" }
      end
    end
end
