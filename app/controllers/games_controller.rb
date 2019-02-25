require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    @alphabet = ('A'..'Z').to_a
    10.times { @letters << @alphabet.sample }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def valid_word?(word, grid_str)
    wrong_letters = 0
    letters = word.upcase.split('')
    grid = grid_str.upcase.split('')
    grid.sort!
    letters.sort!
    letters.each do |letter|
      grid.include?(letter) ? grid.shift : wrong_letters = 1
    end
    wrong_letters.zero?
  end

  def score
    if english_word?(params['word']) && valid_word?(params['word'], params['letters'])
      @score = params['word'].length
      @msg = "Well done!! Your score was "
    else
      @score = 0
      @msg = "Sorry... #{params['word']} is not a valid word. Your score was "
    end
    session[:score] = session[:score].to_i + @score
  end
end

