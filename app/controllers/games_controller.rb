require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample}
    @letters
  end

  def letter_in_grid
    @answer.chars.sort.all? do |letter|
      @grid.include?(letter)
    end
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def score
    @grid = params[:grid]
    @answer = params[:word].upcase
    grid_letters = @grid.each_char { |letter| print letter, ''}
    if !letter_in_grid
      @results = "Sorry, but #{@answer.upcase} can't be built out of #{grid_letters}."
    elsif !english_word
      @results = "Sorry but #{@answer.upcase} does not seem to be a valid English word."
    elsif letter_in_grid && !english_word
      @results = "Sorry but #{@answer.upcase} does not seem to be aa valid English word."
    else letter_in_grid && english_word
      @results = "Congratulation! #{@answer.upcase} is a valid English word."
    end
  end
end
