require 'open-uri'
class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]
  def new
    @letters = Array.new(7) { ('A'..'Z').to_a.sample }
    @letters += Array.new(3) { VOWELS.sample }
    @letters.shuffle!
    @word = params[:word]
  end

  def score
    @score = 0
    @word = params[:word].upcase
    @letters = params[:letters]
    # Verifier si le mot est contenu dans la grid
    if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
      # Vérifier mot contenu dans l'API
      uri = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read
      result = JSON.parse(uri)
      if result['found'] == true
        @score = @word.length
        "Congratulations! #{@word} is a valid English word."
      else
        @score = 0
        "Sorry this #{@word} does not seem to be a valid English word."
      end
    else
      @score = 0
      "Sorry but #{@word} can't be build out of #{@letters}"
    end
  end
end
