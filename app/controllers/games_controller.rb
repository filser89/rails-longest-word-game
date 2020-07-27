require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = generate_letters
    session[:words] ||= []
  end
  def score

    @word = params[:word]
    @letters = params[:letters].split
    @words = session[:words]
    if !has_letters?
      @result = "Sorry but #{@word.upcase} can't be built out of #{@letters.join}"

    elsif !is_english?
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word.upcase} is a valid English word!"
      session[:words].push(@word)
    end
      make_scores_hash
      calc_sum
  end

  def reset
    session.clear
    redirect_to new_path
  end

  def generate_letters
    alphabet = ("A".."Z").to_a
    letters = []
    10.times do
      letter = alphabet.sample
      letters.push(letter)
    end
    letters
  end

  def has_letters?

  @word.upcase.split("").all? { |letter| @letters.count(letter) >= @word.upcase.split("").count(letter) }
  end

  def is_english?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    p url
    response = open(url).read
    data = JSON.parse(response)
    data['found']
  end
  def make_scores_hash
    @scores = {}
    @words.each{|word| @scores["#{word}"] = word.length }

  end
  def calc_sum

    @sum = @scores.values.sum
  end

end
