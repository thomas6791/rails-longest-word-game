class WordController < ApplicationController

  require 'open-uri'
  require 'json'

  def game
    @array = grid_creation
  end

  def score
    @reponse = params[:query]
    @grid = params[:grid]
    @grid_splitted = grid_split(@grid)
    @letters = letters_from_reponse
    @is_english = english_word?(@reponse)
     @resultats = score_and_message(@reponse, @grid)
  end

  def grid_creation
    ('A'..'Z').to_a.sample(9)
  end

  def grid_split(grid)
    grid.split("").to_a
  end

  def score_and_message(attempt, grid)
   if included?(attempt.upcase, grid)
     if english_word?(attempt)
      return "it's correct"
     else
      return "it's false"
     end
    end
  end

  def letters_from_reponse
    letters_of_reponse = @reponse.upcase.split("").to_a #=> Renvoi les letters en capitalize de la réponse dans un array
  end

  def included?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
  end

end
